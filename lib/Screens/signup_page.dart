import 'package:flutter/material.dart';
import 'package:player/Screens/MainScreen.dart';
import 'package:player/Screens/login_page.dart';
import 'package:player/constants.dart';
import 'package:player/Components/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  static String page = 'SignUp_page';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D1117),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 1,
                  child: Icon(
                    Icons.library_music,
                    color: Colors.tealAccent,
                    size: 80.0,
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value){
                  email = value;
                },
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your E-mail',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value){
                  password = value;
                },
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Password',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Button(
                buttonName: 'Sign Up',
                color: Colors.black54,
                onPressed: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(email: email, password: password).catchError((err) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog();
                      });
                    });

                    if (user != null) {
                      Navigator.pushNamed(context, MainScreen.page);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              SizedBox(
                height: 48.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 80.0,right: 80.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Login.page);
                  },
                  child: Text(
                    'Already have any account',
                    style: TextStyle(color: Colors.tealAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

