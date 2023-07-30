import 'package:flutter/material.dart';
import 'package:listen_together_app/models/tokens.dart';
import 'package:listen_together_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/data/user_data.dart';
import '/pages/auth/auth.dart';
import 'package:listen_together_app/services/secure_storage.dart';

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
    debugPrint(_user_data?.userData.toString());
    debugPrint(_tokens.toString());
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
                ? Text(
                    user_data['email'].toString(),
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  )
                : Text('loading...')));
  }
}
