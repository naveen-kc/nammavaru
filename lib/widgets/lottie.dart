import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nammavaru/utils/helpers.dart';


class LottiePage extends StatefulWidget {
  @override
  _LottiePageState createState() => _LottiePageState();
}

class _LottiePageState extends State<LottiePage> {
  Helpers helpers=Helpers();
  @override
  Widget build(BuildContext context) {
    return Container(
        height:MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Center(
            child: SizedBox(
                height: 100.0,
                width: 100.0,
                child: Lottie.asset(
                  helpers.loading,
                  repeat: true,
                  reverse: true,
                  animate: true,
                ),
                //Image.asset('assets/images/loader.gif',fit: BoxFit.fill,) // use you custom loader or default loader
                )
            ));
  }
}