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

}