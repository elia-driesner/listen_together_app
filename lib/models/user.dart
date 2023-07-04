import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserData {
  UserData(this.userData);

  Map userData;
  static String userDataKey = 'user_data';

  static String serialize(userData) {
    return (json.encode(userData));
  }

  static Map deserialize(userData) {
    return (json.decode(userData));
  }

  static Future<void> saveToStorage(userData) async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: userDataKey, value: serialize(userData));
    } catch (e) {
      print(e);
    }
  }

  static Future<UserData?> readFromStorage() async {
    final storage = new FlutterSecureStorage();
    var userData;
    userData = await storage.read(key: userDataKey);
    userData = deserialize(userData);
    debugPrint(userData.toString());
    if (userData == null) return null;

    return UserData(userData);
  }

  Future<void> clearStorage() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(
      key: userDataKey,
    );
  }

  Future<void> updateUserData() async {
    final savedTokens = await readFromStorage();
    if (savedTokens == null) throw Exception("No saved token found");

    // final tokens =
    //     await SpotifyAuthApi.getNewTokens(originalTokens: savedTokens);
    const tokens = true;
    if (tokens) {
      await saveToStorage(tokens);
    }
  }
}
