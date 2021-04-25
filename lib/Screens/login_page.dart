import 'package:flutter/material.dart';
import 'package:player/Screens/MainScreen.dart';
import 'package:player/Screens/signup_page.dart';
import 'package:player/constants.dart';
import 'package:player/Components/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Login extends StatefulWidget {
  static String page = 'Login_page';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
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
                style: TextStyle(color: Colors.white),
                onChanged: (value){
                  email = value;
                },
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
                keyboardType: TextInputType.visiblePassword,
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
                buttonName: 'Log In',
                color: Colors.black54,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password).catchError((err) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(err.message),
                          actions: [
                            ElevatedButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Ok"), ),
                          ],
                        );
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
                    Navigator.pushNamed(context, SignUp.page);
                  },
                  child: Text(
                    'Don\'t have any account',
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
