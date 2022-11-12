import 'package:flutter/material.dart';
import 'package:nammavaru/utils/LocalStorage.dart';
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController=TextEditingController();
  LocalStorage localStorage=LocalStorage();
  String mobile='';
  String password='';
  var ctime;
  bool isInternet=false;


  @override
  void initState(){
    super.initState();

    checkConnection();
  }

  void checkConnection()async{
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
  }

  void userLogin() async{
     if(mobile.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Mobile Number",
              description: "Please proper enter your registered mobile number",
            );    
          });

    }else if(password.isEmpty){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Enter Password",
              description: "Please enter your password",
            );
          });
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        loading = true;
      });
      var data = await  LoginController().login(mobileController.text,passwordController.text);

      if (data['status']) {
        localStorage.putName(data['name']);
        localStorage.putMobile(data['mobile']);
        localStorage.putDob(data['dob']);
        localStorage.putAddress(data['address']);
        localStorage.putVillage(data['village']);
        localStorage.putProfile(data['image']);

        Navigator.pop(context,true);
        Navigator.pushNamed(context, "/home");
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
                header: "Login fail",
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
                    'Login to get to know the updates of us',
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
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    onChanged: (value){
                      mobile=mobileController.text;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      labelText: 'Mobile Number',
                      hintText: 'Mobile Number',
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

                    //maxLength: 10,
                    controller: passwordController,
                    onChanged: (value){
                      password=passwordController.text;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          )
                      ),
                      labelText: 'Password',
                      hintText: 'Password',
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
