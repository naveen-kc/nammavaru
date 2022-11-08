import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/ApiEndpoints.dart';
import 'package:http/http.dart' as http;

class AdminController {

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


    // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   debugPrint(value);
    //
    // });









    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var request = await http.MultipartRequest(
    //     'POST', Uri.parse(ApiConstants.baseUrl + ApiEndpoints.register));
    // request.fields['name'] = name;
    // request.fields['mobile'] = mobile;
    // request.fields['dob'] = dob;
    // request.fields['address'] = address;
    // request.fields['village'] = village;
    // request.fields['password'] = password;
    // request.headers['Accept'] ='application/json';
    //
    // log("request :"+request.toString()+request.fields.toString());
    //
    // request.files.add(await http.MultipartFile.fromPath('image', filepath));
    // var response = await request.send();
    //
    // var responsed = await http.Response.fromStream(response);
    //
    //
    // final responsedData = json.decode(responsed.body);
    //
    // Map<String, dynamic> data = responsedData;
    // print(data);
    // log("added :"+data.toString());
    // if (data['status']) {
    //   return data;
    // } else {
    //   return data;
    // }
  }




