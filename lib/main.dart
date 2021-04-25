import 'package:flutter/material.dart';
import 'package:player/Screens/Home.dart';
import 'package:player/Screens/MainScreen.dart';
import 'package:player/Screens/Upload.dart';
import 'package:player/Screens/login_page.dart';
import 'package:player/Screens/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Home.page,
      routes: {
        Login.page : (context) => Login(),
        SignUp.page : (context) => SignUp(),
        Home.page : (context) => Home(),
        MainScreen.page : (context) => MainScreen(),
        Upload.page : (context) => Upload(),

      },
    );
  }
}
