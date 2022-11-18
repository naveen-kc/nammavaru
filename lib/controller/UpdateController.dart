import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';
import 'package:http/http.dart' as http;


class UpdateController{

  BaseApiService _apiService = NetworkApiService();


  Future<dynamic> updateNow(String description,filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiEndpoints.addUpdate));
    request.fields['name'] = prefs.getString('name')!;
    request.fields['mobile'] =  prefs.getString('mobile')!;
    request.fields['village'] =  prefs.getString('village')!;
    request.fields['description'] = description;
    request.fields['profile'] = prefs.getString('image')!;
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

  Future<dynamic> getIndividualUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.getIndividualUpdate, {
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

  Future<dynamic> deleteUpdate(String time,String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.deleteUpdate, {
      "mobile":prefs.getString("mobile")!,
      "time":time,
      "image":image
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