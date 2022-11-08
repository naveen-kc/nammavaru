import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../widgets/app_button.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.black,
        iconTheme: IconThemeData(
        color: AppColors.white,
    ),
    elevation: 0,
    title: Text(
    "Admin",
    style: TextStyle(fontFamily: 'HindBold', color: AppColors.white),
    )),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Button(
                  elevation: 0.0,
                  textColor: Colors.white,
                  backgroundColor: AppColors.black,
                  text: 'Add program',
                  width: 330,
                  height: 50,
                  fontSize: 18,
                  onPressed: () {
                    Navigator.pushNamed(context, '/addProgram');

                  },
                  borderRadius: BorderRadius.circular(10), fontFamily: 'HindBold',
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Button(
                  elevation: 0.0,
                  textColor: Colors.white,
                  backgroundColor: AppColors.black,
                  text: 'View Requests',
                  width: 330,
                  height: 50,
                  fontSize: 18,
                  onPressed: () {

                  },
                  borderRadius: BorderRadius.circular(10), fontFamily: 'HindBold',
                ),
              ),
            ],
          ),
    ));
  }
}
