import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';

class ProfileController{
  BaseApiService _apiService = NetworkApiService();



  Future<dynamic> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.getProfile, {
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


  Future<dynamic> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.updateProfile, {
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