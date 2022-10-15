import 'package:flutter/material.dart';
import 'package:nammavaru/screens/Home.dart';
import 'package:nammavaru/screens/Login.dart';
import 'package:nammavaru/screens/Profile.dart';
import 'package:nammavaru/screens/Register.dart';
import 'package:nammavaru/screens/Splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/register': (context) => Register(),

      },
    );
  }
}