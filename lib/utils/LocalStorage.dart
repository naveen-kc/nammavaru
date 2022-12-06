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

  void putName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
  }
  void putMobile(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("mobile", mobile);
  }
  void putDob(String dob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("dob", dob);
  }

  void putAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", address);
  }

  void putVillage(String village) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("village", village);
  }

  void putProfile(String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("image", image);
  }

  void putDeviceToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("device_token", token);
  }

  void putPaid(String paid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("paid", paid);
  }

  void putAppVersion(String version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("appVersion", version);
  }





}