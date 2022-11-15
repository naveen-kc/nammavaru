import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';
import 'package:http/http.dart' as http;

class LoginController{
  BaseApiService _apiService = NetworkApiService();


  Future<dynamic> login(String phone,String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.login, {
      "mobile":phone,
      "password":pass,
    },);
    Map<String,dynamic> data = response;
    if(data["status"]==200){
      return data;
    }
    else{
      return data;
    }
  }



  Future<dynamic> register(String name,String mobile,String dob,String address,String village,String password,filepath) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiEndpoints.register));
    request.fields['name'] = name;
    request.fields['mobile'] = mobile;
    request.fields['dob'] = dob;
    request.fields['address'] = address;
    request.fields['village'] = village;
    request.fields['password'] = password;
    request.fields['token']=prefs.getString("device_token")!;
    request.headers['Accept'] ='application/json';

    log("request :"+request.toString()+request.fields.toString());

    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();

    var responsed = await http.Response.fromStream(response);


    final responsedData = json.decode(responsed.body);

    Map<String, dynamic> data = responsedData;
    print(data);
    log("added :"+data.toString());
     if (data['status']) {
       return data;
     } else {
       return data;
     }
  }

}