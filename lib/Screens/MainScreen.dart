import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:player/Screens/Upload.dart';
import 'package:player/Screens/profile.dart';

class MainScreen extends StatefulWidget {
  static String page = 'MainScreen_page';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _songs = [];
  List<DocumentSnapshot> _images = [];
  bool _loadingImages = true;
  bool _loadingSongs = true;
  User loggedInUser;
  int _perPage = 25;
  DocumentSnapshot _documentSnapshot;
  ScrollController _scrollController = ScrollController();
  bool _gettingMoreSongs = false;
  bool _moreSongsAvailable = true;
  bool playing = false;
  IconData playBtn = Icons.play_arrow;
  AudioPlayer audioPlayer = AudioPlayer();
  bool liking;
  IconData likeBtn = Icons.favorite_border;

  void _getSong() async {
    Query query =
        _firestore.collection("songs").orderBy('time').limit(_perPage);

    setState(() {
      _loadingSongs = true;
    });
    QuerySnapshot querySnapshot = await query.get();
    _documentSnapshot = querySnapshot.docs[querySnapshot.docs.length - 1];
    _songs = querySnapshot.docs;
    setState(() {
      _loadingSongs = false;
    });
  }

  void _getMoreSongs() async {
    print('get more songs.');

    if (_moreSongsAvailable == false) {
      print('no more songs.');
      return;
    }
    if (_gettingMoreSongs == true) {
      return;
    }
    _gettingMoreSongs = true;
    Query query = _firestore
        .collection("songs")
        .orderBy('time')
        .startAfter([_documentSnapshot.data()['time']]).limit(_perPage);
    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.length < _perPage) {
      _moreSongsAvailable = false;
    }

    _documentSnapshot = querySnapshot.docs[querySnapshot.docs.length - 1];
    _songs.addAll(querySnapshot.docs);
    setState(() {
      _moreSongsAvailable = false;
    });
  }

  Future getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  playSongs(int index) {
    audioPlayer.play(
      _songs[index].data()['url'],
    );
  }

  stopSong() {
    audioPlayer.stop();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _getSong();
    _getMoreSongs();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll > delta) {
        _getMoreSongs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D1117),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 20.0,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            decoration: BoxDecoration(
              color: Colors.tealAccent,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.upload_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, Upload.page)),
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 30.0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(child: Text(loggedInUser.email,style: TextStyle(color: Colors.white),)),
                  ),
                ),  
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: _loadingSongs == true
                  ? Container(
                      child: Center(
                        child: Text(
                          'Loading.....',
                          style: TextStyle(fontSize: 30.0, color: Colors.white),
                        ),
                      ),
                    )
                  : Container(
                      child: _songs.length == 0
                          ? Center(
                              child: Text('NO Songs to show'),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _songs.length,
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  child: ListTile(
                                    trailing: IconButton(
                                      icon: Icon(
                                        likeBtn,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (!liking) {
                                            likeBtn = Icons.favorite;
                                            liking = true;
                                          } else {
                                            likeBtn = Icons.favorite_border;
                                            liking = true;
                                          }
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      {
                                        if (playing == false) {
                                          playSongs(index);
                                        } else {
                                          stopSong();
                                        }
                                      }
                                    },
                                    leading: Icon(
                                      Icons.library_music,
                                      color: Colors.tealAccent,
                                    ),
                                    title: Text(
                                      _songs[index].data()['songName'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
