import 'package:flutter/material.dart';
import 'package:nammavaru/utils/constants.dart';

class Loader extends StatelessWidget {
  double? height;
  double? width;
  Colors? colorValue;
  Loader({this.colorValue});

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Container(
        height: height,
        width: width,
        color: Colors.transparent,
        child: Center(
            child: SizedBox(
                height: 60.0,
                width: 60.0,
                child:
                //Image.asset('assets/images/loader.gif',fit: BoxFit.fill,) // use you custom loader or default loader
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        AppColors.soil),
                    strokeWidth: 5.0))));
  }
}



