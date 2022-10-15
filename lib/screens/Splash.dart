import 'package:flutter/material.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:nammavaru/utils/helpers.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Helpers helpers=Helpers();


  @override
  void initState(){
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context, true);
      Navigator.pushNamed(context, '/login');
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children :[
          Image.asset(
          helpers.pottering,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
          Align(
            alignment: Alignment(0, 0.8),
            child: Text(
              'Nammavaru',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'HindMedium',
                fontSize: 20.0,
              ),
            ),
          )

          ]
      ),
    );
  }
}
