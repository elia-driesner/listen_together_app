import 'package:flutter/material.dart';
import '/data/user_data.dart';
import '/pages/auth/auth.dart';
import 'package:listen_together_app/services/secure_storage.dart';

import 'package:spotify_api/spotify_api.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void checkLogin(context) async {
    await SecureStorage.init();
    // await SecureStorage.clearData();
    var _user_data = await SecureStorage.getUserData();
    var _tokens = await SecureStorage.getJWT();
    if (_user_data == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => EmailPage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      setState(() {
        user_data = _user_data.userData['data'];
        jwt = _tokens as Map;
      });
      if (user_data['spotify_refresh_token'] == "") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SpotifyConnectPage(
                    email: user_data['email'],
                    password: user_data['password'],
                    uid: user_data['uid'])));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLogin(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: user_data != null
                ? Text(user_data['spotify_refresh_token'].toString())
                : Text('loading...')));
  }
}
