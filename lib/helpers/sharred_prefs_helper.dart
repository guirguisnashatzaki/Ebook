

import 'package:shared_preferences/shared_preferences.dart';

class SharredPrefsHelper{

  final String LOGIN_KEY = "loginKey";

  SharedPreferences? prefs;

  SharredPrefsHelper() {
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> login(String email) async {
    await prefs?.setString(LOGIN_KEY,email);
  }

  logout() async {
    await prefs?.remove(LOGIN_KEY);
  }

  Future<String> checkLog() async {
    return prefs?.getString(LOGIN_KEY) ?? "";
  }
}