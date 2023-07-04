import 'package:flutter/material.dart';
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
    await SecureStorage.clearUserData();
    var userData = await SecureStorage.getUserData();
    var tokens = await SecureStorage.getAuthTokens();
    if (userData == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginPage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      user_data = userData;
      jwt = tokens as Map;
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
