import 'package:flutter/material.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import '/data/user_data.dart';
import 'package:authentication/authentication.dart';
import 'package:listen_together_app/services/data.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final auth = Authentication();
  void checkLogin(context) async {
    await Data.init();
    // await SecureStorage.clearData();
    Data.initApp(context);
    user_data = await SecureStorage.getUserData();
    debugPrint(user_data.userData.toString());
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
                : const Text('loading...')));
  }
}
