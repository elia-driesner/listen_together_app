import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static late SharedPreferences _preferences;

  static const _keyUserData = 'user_data';
  static const _keyTokens = 'jwt_tokens';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserData(Map user_data) async {
    String encodedUserData = json.encode(user_data);
    await _preferences.setString(_keyUserData, encodedUserData);
  }

  static Map? getUserData() {
    String? encodedUserData = _preferences.getString(_keyUserData);
    if (encodedUserData == null) {
      return null;
    } else {
      Map userData = json.decode(encodedUserData);
      return (userData);
    }
  }

  static Future setTokens(Map tokens) async {
    String encodedTokens = json.encode(tokens);
    await _preferences.setString(_keyTokens, encodedTokens);
  }

  static Map? getTokens() {
    String? encodedTokens = _preferences.getString(_keyTokens);
    if (encodedTokens == null) {
      return null;
    } else {
      Map tokens = json.decode(encodedTokens);
      return (tokens);
    }
  }

  static Future deleteData() async {
    await _preferences.remove(_keyUserData);
    await _preferences.remove(_keyTokens);
  }
}
