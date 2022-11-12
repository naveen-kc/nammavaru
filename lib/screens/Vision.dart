import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nammavaru/network/ApiEndpoints.dart';
import 'package:nammavaru/utils/constants.dart';


class Vision extends StatefulWidget {
  const Vision({Key? key}) : super(key: key);

  @override
  State<Vision> createState() => _VisionState();
}

class _VisionState extends State<Vision> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.soil,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          elevation: 0,
          title: Text(
            "Our Vision",
            style: TextStyle(fontFamily: 'HindBold', color: AppColors.black),
          )),
      body: SafeArea(
        child:Column(
            children:[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('This Nammavaru app is a completely assosiated with the Kumbara community,Sringeri and our vision is to grow our community to make stronger and together.We have ambitions to help the poor ones who is struggling to live and make sure their children to get a good education for the future.Also we from this app the people of our community will get to know each other well and our relationship with us will be good.',
                style: TextStyle(
                  color: AppColors.darkSoil,
                  fontFamily: 'HindMedium',
                  fontSize: 22
                ),),
              )


              
            ]

          ),

      ),
    );
  }
}
