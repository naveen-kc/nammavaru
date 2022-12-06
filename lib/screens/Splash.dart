import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nammavaru/controller/LoginController.dart';
import 'package:nammavaru/utils/LocalStorage.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:nammavaru/utils/helpers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/alert_box.dart';
import '../widgets/no_internet.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Helpers helpers=Helpers();
  String? mobile=null;
  bool isInternet = false;
  String appVersion='';
  LocalStorage localStorage=LocalStorage();


  @override
  void initState(){
    super.initState();
    getAppVersion();
    checkConnection();

  }

  void getAppVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    log("appversion => $appVersion");
    localStorage.putAppVersion(appVersion);
  }


  void checkConnection() async {

    isInternet = await Helpers().isInternet();

    if (isInternet) {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      checkVersion();

    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return NoInternet(
              header: "No Internet",
              description:
              "Please check your data connectivity or try again in some time.",
              move: '/splash',
            );
          });
    }
  }

  checkSession()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    final form = prefs.getString("mobile");
    mobile = form;
    mobile = prefs.getString("mobile");
    if(mobile==null){
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, true);
        Navigator.pushNamed(context, '/login');
      });
    }else {
      Future.delayed(Duration(seconds: 1), () {
        if(prefs.getString("paid")=='1'){
          Navigator.pop(context, true);
          Navigator.pushNamed(context, '/home');
        }else{
          Navigator.pop(context, true);
          Navigator.pushNamed(context, '/decision');
        }

      });
    }

  }


  void checkVersion() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var data = await LoginController().versionCheck();

    if (data["status"]) {
      if (data["version"] != prefs.getString("appVersion")) {

        if(data["force_update"] == '1'){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertBox(
                    header: 'Update available',
                    description:  'New version is available in Play store, please upgrade the app for the better experience',
                    okay: () {},
                    cancel: () {
                      exit(0);
                    },
                    yes: 'Update',
                    no: 'Exit');
              });
        }else{
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertBox(
                    header: 'Update available',
                    description: 'New version is available in Play store, please upgrade the app for the better experience',
                    okay: () {},
                    cancel: () {
                      checkSession();
                    },
                    yes: 'Update',
                    no: 'Later');
              });
        }
      } else {
        checkSession();
      }
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
