import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';



class Upload extends StatefulWidget {
  static String page = 'Upload_page';

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  String _sonName;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  List<UploadTask> uploadedTasks = List();

  List<File> selectedFiles = List();
  uploadFileToStorage(File file) {
    UploadTask task = _firebaseStorage
        .ref()
        .child("Songs/${DateTime.now().toString()}")
        .putFile(file);
    return task;
  }
  writeSongUrlToFireStore(songUrl) {
    _firebaseFirestore.collection("songs").add({"url": songUrl,"songName":_sonName,"time":DateTime.now().toString()}).whenComplete(
            () => print("$songUrl is saved in Firestore"));
  }
  saveSongUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref
            .getDownloadURL()
            .then((songUrl) => writeSongUrlToFireStore(songUrl));
      }
    });
  }

  Future selectFileToUpload() async {
    try {
      FilePickerResult result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: FileType.audio);

      if (result != null) {
        selectedFiles.clear();

        result.files.forEach((selectedFile) {
          File file = File(selectedFile.path);
          selectedFiles.add(file);
        });

        selectedFiles.forEach((file) {
          final UploadTask task = uploadFileToStorage(file);
          saveSongUrlToFirebase(task);

          setState(() {
            uploadedTasks.add(task);
          });
        });
      } else {
        print("User has cancelled the selection");
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xff0D1117),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("UPLOAD"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        onPressed: () {
          selectFileToUpload();
          Navigator.pop(context);
        },
        child: Icon(Icons.add,color: Colors.black,),
      ),
      body: uploadedTasks.length == 0
          ? Center(child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: TextField(
          onChanged: (value)=> _sonName = value,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            hintText: 'Enter the Song Name',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      )
          : ListView.separated(
        itemBuilder: (context, index) {
          return StreamBuilder<TaskSnapshot>(
            builder: (context, snapShot) {
              return
                snapShot.hasError
                    ? Text("There is some error in uploading file")
                    : snapShot.hasData ?
                Center(
                  child: ListTile(
                    title: Text("${snapShot.data.bytesTransferred}/${snapShot.data.totalBytes} ${snapShot
                        .data.state == TaskState.success ? "Completed" : snapShot.data.state == TaskState.running ? "In Progress" : "Error"}",style: TextStyle(color: Colors.white),),
                  ),
                ) : Container();
            },
            stream: uploadedTasks[index].snapshotEvents,
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: uploadedTasks.length,
      ),
    );
  }
}
