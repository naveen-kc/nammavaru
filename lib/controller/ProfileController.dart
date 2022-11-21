import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';
import 'package:http/http.dart' as http;

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


  Future<dynamic> getFamily() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.getFamily, {
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


  Future<dynamic> updateProfile(String updatedName,String updatedDob,String updatedVillage,String updatedAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.editProfile, {
      "mobile":prefs.getString("mobile")!,
      "name":updatedName,
      "address":updatedAddress,
      "village":updatedVillage,
      "dob":updatedDob,

    },);
    Map<String,dynamic> data = response;
    if(data["status"]==200){
      return data;
    }
    else{
      return data;
    }
  }


  Future<dynamic> changeImage(filepath) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiEndpoints.changeProfile));

    request.fields['mobile'] = prefs.getString('mobile')!;
    request.fields['old_image'] = prefs.getString('image')!;

    log("request :"+request.toString()+request.fields.toString());

    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();

    var responsed = await http.Response.fromStream(response);

    final responsedData = json.decode(responsed.body);

    Map<String, dynamic> data = responsedData;
    print(data);

    if (data['status']) {
      return data;
    } else {
      return data;
    }
  }

  Future<dynamic> addFamilyMembers(String name,String age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.addFamily, {
      "mobile":prefs.getString("mobile")!,
      "name":name,
      "age":age,


    },);
    Map<String,dynamic> data = response;
    if(data["status"]==200){
      return data;
    }
    else{
      return data;
    }
  }

  Future<dynamic> deleteFamilyMember(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.deleteMember, {
      "mobile":prefs.getString("mobile")!,
      "name":name,


    },);
    Map<String,dynamic> data = response;
    if(data["status"]==200){
      return data;
    }
    else{
      return data;
    }
  }



  Future<dynamic> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.deleteAccount, {
      "mobile":prefs.getString("mobile")!,
      "image":prefs.getString("image")!,



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