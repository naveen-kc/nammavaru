import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:nammavaru/network/AppException.dart';
import 'package:nammavaru/network/BaseApiService.dart';
import 'package:http/http.dart' as http;
import 'AppException.dart';
import 'BaseApiService.dart';

class NetworkApiService extends BaseApiService {
  @override
  Future getResponse(String url) async {
    url;
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url));
      log("$url");
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  @override
  Future postResponse(
      String baseUrl, String url, Map<String, dynamic> JsonBody) async {
    dynamic responseJson;
    log("$baseUrl$url$JsonBody");
    try {
      final response =
          await http.post(Uri.parse(baseUrl + url), body: JsonBody);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    print(responseJson);
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    print(response.toString());
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
