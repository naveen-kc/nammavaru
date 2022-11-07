import 'package:flutter/material.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:nammavaru/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Helpers helpers=Helpers();
  String? mobile=null;


  @override
  void initState(){
    super.initState();
    checkSession();

  }
  checkSession()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    final form = prefs.getString("mobile");
    mobile = form;
    mobile = prefs.getString("mobile");
    if(mobile==null){
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context, true);
        Navigator.pushNamed(context, '/login');
      });
    }else {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context, true);
        Navigator.pushNamed(context, '/home');
      });
    }

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
