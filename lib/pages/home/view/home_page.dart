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
    await AuthTokens.init(SecureStorage.getStorage()['storage']);
    await SecureStorage.clearUserData();
    var _user_data = await UserData.readFromStorage();
    var _tokens = await AuthTokens.readJWT();
    debugPrint(_user_data.toString());
    debugPrint(_tokens.toString());
    if (_user_data == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginPage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      user_data = _user_data;
      jwt = _tokens as Map;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLogin(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: const Text('homepage')));
  }
}
