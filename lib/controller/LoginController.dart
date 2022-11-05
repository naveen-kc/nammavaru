import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';

class LoginController{
  BaseApiService _apiService = NetworkApiService();


  Future<dynamic> login(String email,String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.login, {
      "email":email,
      "mobile":mobile,
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