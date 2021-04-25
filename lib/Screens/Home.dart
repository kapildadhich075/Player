import 'package:flutter/material.dart';
import 'package:player/Components/Button.dart';
import 'package:player/Screens/login_page.dart';
import 'package:player/Screens/signup_page.dart';

class Home extends StatefulWidget {
  static String page = 'Home_page';


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D1117),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(tag: 1,child: Icon(Icons.library_music,color: Colors.tealAccent,size: 80.0,)),
            SizedBox(
              height: 48.0,
            ),
            Button(
              buttonName: 'Log In',
              color: Colors.black54,
              onPressed: () {
                Navigator.pushNamed(context, Login.page);
              },
            ),

            Button(
              buttonName: 'Sign Up',
              color: Colors.black54,
              onPressed: () {
                Navigator.pushNamed(context, SignUp.page);
              },
            ),
          ],
        ),
      ),
    );
  }
}
