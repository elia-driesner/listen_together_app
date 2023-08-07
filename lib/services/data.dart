import 'package:authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import '/pages/auth/auth.dart';
import '/pages/houseparty/houseparty.dart';

class Data {
  static Future<void> init() async {
    await SecureStorage.init();
  }

  static Future<Map> readData() async {
    var _user_data = await SecureStorage.getUserData();
    var _tokens = await SecureStorage.getJWT();
    var user_data;
    var tokens;
    if (_user_data != null) {
      user_data = _user_data.userData['data'];
    }
    if (_tokens != null) {
      tokens = _tokens['user_tokens'];
    }
    return {'user_data': user_data, 'tokens': tokens};
  }

  static Future<void> initApp(context) async {
    var data = await readData();
    var user_data = data['user_data'];
    var tokens = data['tokens'];

    if (user_data == null || tokens == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => UsernamePage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      if (user_data['spotify_refresh_token'] == "") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SpotifyConnectPage(
                    username: user_data['username'],
                    password: user_data['password'],
                    uid: user_data['uid'])));
      } else {
        await updateData(user_data, tokens);
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => StartPartyPage(),
            transitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  static Future<void> updateData(user_data, tokens) async {
    String refresh_token = tokens['refresh_token'];
    var new_data = await Authentication.RenewData(user_data, refresh_token);
    SecureStorage.setAuthToken(new_data['tokens']);
    SecureStorage.setUserData(new_data['user_data']);
  }
}
