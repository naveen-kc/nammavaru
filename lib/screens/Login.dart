import 'package:flutter/material.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/LoginController.dart';
import '../utils/helpers.dart';
import '../widgets/app_button.dart';
import '../widgets/dialog_box.dart';
import '../widgets/loader.dart';
import '../widgets/no_internet.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading=false;
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController=TextEditingController();
  String email='';
  String mobile='';
  var ctime;
  bool isInternet=false;


  @override
  void initState(){
    super.initState();

  }

  void userLogin() async{
    isInternet = await Helpers().isInternet();
    if(!isInternet){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return NoInternet(
              header: "No Internet",
              description:
              "Please check your data connectivity or try again in some time.",
              move: '/login',
            );
          });
    }
   else if(email.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Email",
              description: "Please proper enter your email address",
            );
          });

    }else if(mobile.isEmpty ||mobile.length<10){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Mobile Number",
              description: "Please enter your mobile number",
            );
          });
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      var data = await  LoginController().login(emailController.text,mobileController.text);

      if (data['status']==200) {
        Navigator.pushNamed(context, "/verify",arguments: {"isRegister":false,"mobile":mobileController.text});
        setState(() {
          loading = false;
        });
      }else{
        setState(() {
          loading = false;
        });

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AppDialog(
                header: "Error",
                description: data['message'],
              );
            });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    var helpers = Helpers();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: SafeArea(
            child:loading?Loader(): Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 5, 5),
                  child: Text(
                    'Login to \nNammavaru',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'HindBold'
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'We\'ll text you OTP to verify your credentials',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'HindRegular'
                    ),
                  ),
                ),

                SizedBox(
                  height: 80,
                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    controller: emailController,
                    onChanged: (value){
                      email=emailController.text;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      labelText: 'Email',
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          fontFamily: 'HindRegular'
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    //maxLength: 10,
                    controller: mobileController,
                    onChanged: (value){
                      mobile=mobileController.text;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      labelText: 'Mobile number',
                      hintText: 'Mobile number',
                      hintStyle: TextStyle(
                          fontFamily: 'HindRegular'
                      ),
                      labelStyle: TextStyle(
                          color: Colors.black,
                        fontFamily: 'HindRegular',
                      ),focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black,
                      ),
                    ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.center,
                  child:
                  Button(
                    elevation: 0.0,
                    textColor: Colors.white,
                    backgroundColor: AppColors.soil,
                    text: 'Login',
                    width: 300,
                    height: 50,
                    fontSize: 18,
                    onPressed: () {
                      userLogin();
                    },
                    borderRadius: BorderRadius.circular(25), fontFamily: 'HindBold',
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child:
                  Button(
                    elevation: 0.0,
                    textColor: Colors.white,
                    backgroundColor: AppColors.soil,
                    text: 'Register',
                    width: 300,
                    height: 50,
                    fontSize: 18,
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    borderRadius: BorderRadius.circular(25), fontFamily: 'HindBold',
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }




  Future<bool> _onWillPop() async {


    DateTime now = DateTime.now();
    if (ctime == null || now.difference(ctime) > Duration(seconds: 2)) {
      //add duration of press gap
      ctime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Press Back Button Again to Exit',
          style: TextStyle(
            fontFamily: 'HindRegular'
          ),))); //scaffold message, you can show Toast message too.
      return Future.value(false);
    }

    return Future.value(true);

    return false;
  }
}
