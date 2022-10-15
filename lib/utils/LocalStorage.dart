import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {


  void putGetStarted(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("value", value);
  }

  void putVerified(String verified) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("verified", verified);
  }
}