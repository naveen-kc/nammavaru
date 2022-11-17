import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import '../network/ApiEndpoints.dart';
import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';

class PaymentController{
  BaseApiService _apiService = NetworkApiService();


  Future<dynamic> getToken(String amount,String reason) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.getPaymentToken, {
      "mobile":prefs.getString("mobile"),
      "name":prefs.getString("name"),
      "amount":amount,
      "reason":reason

    },);

    Map<String,dynamic> data = response;
    if(data["status"]==200){
      return data;
    }
    else{
      return data;
    }

  }
  Future<dynamic> addPayment(String amount,String reason,String status,String order_id,String cf_order_id,String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.addPayment, {
      "mobile":prefs.getString("mobile"),
      "name":prefs.getString("name"),
      "amount":amount,
      "reason":reason,
      "status":status,
      "order_id":order_id,
      "cf_order_id":cf_order_id,
      "token":token,

    },);

    log("resposssss :"+response.toString());

    Map<String,dynamic> data = response;
    if(data["status"]){
      return data;
    }
    else{
      return data;
    }

  }



  Future<dynamic> getPayments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.getPayments, {
      "mobile":prefs.getString("mobile")!,
    },);
    Map<String,dynamic> data = response;
    if(data["status"]==200){
      return data;
    }
    else{
      return data;
    }
  }

}