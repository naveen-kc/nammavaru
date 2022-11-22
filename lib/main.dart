import 'package:flutter/material.dart';
import 'package:nammavaru/admin/AddBanner.dart';
import 'package:nammavaru/admin/AddProgram.dart';
import 'package:nammavaru/admin/AdminHome.dart';
import 'package:nammavaru/admin/AllUsers.dart';
import 'package:nammavaru/screens/AddUpdate.dart';
import 'package:nammavaru/screens/DetailedGallery.dart';
import 'package:nammavaru/screens/Home.dart';
import 'package:nammavaru/screens/Login.dart';
import 'package:nammavaru/screens/Privacy.dart';
import 'package:nammavaru/screens/Profile.dart';
import 'package:nammavaru/screens/Register.dart';
import 'package:nammavaru/screens/Splash.dart';
import 'package:nammavaru/screens/Updates.dart';
import 'package:nammavaru/screens/Vision.dart';

import 'admin/AddAchievers.dart';

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
        '/vision': (context) => Vision(),
        '/register': (context) => Register(),
        '/privacy': (context) => Privacy(),
        '/detailedGallery': (context) => DetailedGallery(),
        '/addUpdate': (context) => AddUpdate(),
        '/updates': (context) => Updates(),

        //Admin Screens
        '/adminHome': (context) => AdminHome(),
        '/addProgram': (context) => AddProgram(),
        '/addAchievers': (context) => AddAchievers(),
        '/addBanner': (context) => AddBanner(),
        '/users': (context) => AllUsers(),

      },
    );
  }
}