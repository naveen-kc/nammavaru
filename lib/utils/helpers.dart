import 'dart:io';

class Helpers {
  var pottering = "assets/images/pottering.jpg";
  var person = "assets/images/person.png";




  Future<bool> isInternet() async {
    bool connected = false;
    print("Checking internet...");
    try {
      final result = await InternetAddress.lookup('google.com');
      final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');
      if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
        print('connected..');
        connected = true;
      } else {
        print("not connected from else..");
        connected = false;
      }
    } on SocketException catch (_) {
      print('not connected...');
      connected = false;
    }
    return connected;
  }


}