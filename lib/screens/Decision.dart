import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:nammavaru/utils/Helpers.dart';
import 'package:nammavaru/utils/LocalStorage.dart';
import 'package:nammavaru/utils/constants.dart';
import 'package:nammavaru/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/PaymentController.dart';
import '../widgets/alert_box.dart';
import '../widgets/app_button.dart';
import '../widgets/dialog_box.dart';

class Decision extends StatefulWidget {
  const Decision({Key? key}) : super(key: key);

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {

  Helpers helpers=Helpers();
  String orderId = "";
  String orderToken = "";
  String cf_order_id="";
  CFEnvironment environment = CFEnvironment.SANDBOX;
  var cfPaymentGatewayService = CFPaymentGatewayService();
  bool loading =false;
  String reason='';
  String amount='';
  Map<dynamic,dynamic> tokenData={};
  List<dynamic> tData=[];
  LocalStorage localStorage=LocalStorage();


  @override
  void initState(){
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);





  }

  void verifyPayment(String orderId)async {
    setState(() {
      loading=true;
    });
    var data=await PaymentController().addPayment("100", "Registration", "Success", orderId, cf_order_id, orderToken);

    if(data["status"]){
      setState(() {
        loading=false;

      });
      localStorage.putPaid('1');

      Navigator.popUntil(context, (route) => route.settings.name=='/splash');
      Navigator.pushNamed(context, "/home");
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Registration Success",
              description: "You have been registered successfully. Thank you for showing your interest in our community development.",
            );
          });
    }else{
      setState(() {
        loading=false;
      });

    }
  }

  void onError(CFErrorResponse errorResponse, String orderId)async {
    setState(() {
      loading=true;
    });
    var data=await PaymentController().addPayment("100", "Member Reg", "Failed", orderId, cf_order_id, orderToken);

    if(data["status"]){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Payment Failed",
              description: data['message']+" Error while making payment",
            );
          });
      setState(() {
        loading=false;
      });
    }else{
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AppDialog(
              header: "Payment Failed",
              description: data['message']+" Error while making payment",
            );
          });
      setState(() {
        loading=false;
      });

    }
  }



  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setOrderToken(orderToken).build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  pay() async {
    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      // components.add(CFPaymentModes.CARD);
      //components.add(CFPaymentModes.WALLET);
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#9B7653").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);


    } on CFException catch (e) {
      print(e.message);
    }

  }





  void getPaymentToken()async{



      setState(() {

        loading=true;
      });
      var data = await PaymentController().getToken("100", "Registration");

      if (data['status']) {


        tData=data['data'];
        log('tData :' + tData.toString());

        Map valueMap = jsonDecode(tData[0]);


        orderId=valueMap['order_id'].toString();
        orderToken=valueMap['order_token'].toString();
        cf_order_id=valueMap['cf_order_id'].toString();
        log('tokennnnn :' + orderToken.toString());

       if(mounted){
         setState(() {

           loading=false;
         });

       }
        pay();

      }

  }

  void logout()async{

    SharedPreferences prefs=await SharedPreferences.getInstance();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertBox(
            header: "Logout",
            description: "If you logout now,you will have to login with same credentials.",
            okay: () {
              prefs.clear();

              Navigator.popUntil(context, (route) => route.settings.name=='/login');
              Navigator.pushNamed(context, '/login');
            },

          );
        });




  }


  @override
  Widget build(BuildContext context) =>
      Scaffold(
    body:   Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          loading?Loader(): Container(
            height:MediaQuery.of(context).size.height,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 10),
                    child: Text(
                        'Registration',
                        style: TextStyle(
                            color: AppColors.black,
                            fontSize: 35,
                            fontFamily: 'HindMedium'

                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                        'You need to pay ₹ 100 as the Member Registration fee,so that you can get all the updates from our community.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: AppColors.black,
                        fontSize: 18,
                        fontFamily: 'HindRegular'

                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
                    child: Row(
                      children: [
                        Button(
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(10),
                          textColor: AppColors.white,
                          backgroundColor: AppColors.soil,
                          text:'Logout',
                          width: 150,
                          height: 15,
                          fontFamily: 'OpenMedium',
                          onPressed: () {
                            logout();
                          },
                        ),
                        Spacer(),
                        Button(
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(10),
                          textColor: AppColors.white,
                          backgroundColor: AppColors.soil,
                          text: 'Pay Now',
                          width: 150,
                          height: 15,
                          fontFamily: 'OpenMedium',
                          onPressed: () {

                            getPaymentToken();
                          },
                        ),
                      ],
                    ),
                  ),

                ],
              ),
              decoration: new BoxDecoration(
                color: const Color(0xffd6d6d6),
                image: new DecorationImage(
                  fit: BoxFit.fitHeight,
                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: new AssetImage(
                      helpers.pottering),
                ),
              ),
            ),

        ],
      ),
  );

}

