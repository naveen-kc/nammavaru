import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import 'package:http/http.dart' as http;

import '../network/BaseApiService.dart';
import '../network/NetworkApiService.dart';

class AdminController {
  BaseApiService _apiService = NetworkApiService();

  Future<dynamic> addProgram(List<XFile>? imageFileList,String name,String description,String date,String videoIds) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.baseUrl+ApiEndpoints.addProgram));
    List<XFile> _image = imageFileList!;


    for (var i = 0; i < _image.length; i++) {
      request.files.add(http.MultipartFile('photos[]',
          File(_image[i].path).readAsBytes().asStream(), File(_image[i].path).lengthSync(),
          filename: _image[i].path.split("/").last));
    }
    // listen for response
      request.fields['name'] = name;
      request.fields['description'] = description;
      request.fields['date'] = date;
      request.fields['videoIds'] = videoIds;


      log('Datsssss :'+name+description+date+videoIds);


    // send
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




  Future<dynamic> addAchievers(String name,String village,String achieve,filepath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiEndpoints.addAchievers));
    request.fields['name'] = name;
    request.fields['village'] =  village;
    request.fields['achieve'] = achieve;
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



  Future<dynamic> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await _apiService.postResponse(ApiConstants.baseUrl,ApiEndpoints.getUsers, {
      //"mobile":prefs.getString("mobile")!,
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




