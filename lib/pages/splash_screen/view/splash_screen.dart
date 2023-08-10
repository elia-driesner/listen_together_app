import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:authentication/authentication.dart';
import '../../../services/data.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import '../../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget? loadingIndicator;
  String errorMessage = '';

  void loadApp() async {
    if (Platform.isAndroid) {
      loadingIndicator = const CircularProgressIndicator();
    } else {
      loadingIndicator = const CupertinoActivityIndicator(radius: 18);
    }
    setState(() {
      loadingIndicator;
      errorMessage = '';
    });
    bool connection = await Authentication.checkConnection();
    await Data.init();
    if (connection) {
      Data.initApp(context);
      var _user_data = await SecureStorage.getUserData();
      if (_user_data != null) {
        var user_data = _user_data.userData;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      }
    } else {
      setState(() {
        errorMessage = 'No Connection to the Server';
        loadingIndicator = null;
      });
    }
  }

  @override
  void initState() {
    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(
                        0, (MediaQuery.of(context).size.height * 0), 0, 0),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width * 0.45),
                      child: Image.asset(
                          fit: BoxFit.cover, 'assets/icons/logo/ios.png'),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      0, (MediaQuery.of(context).size.height * 0), 0, 0),
                  child: Text(
                    'By Elia Driesner',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: loadingIndicator),
          const Spacer(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(errorMessage,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.error,
                    fontSize: (MediaQuery.of(context).size.width * 0.042))),
          ),
          Container(
              child: Text(
            'V0.1 Beta Test',
            style: TextStyle(
                color: Theme.of(context).primaryColorLight, fontSize: 14),
          )),
        ],
      )),
    );
  }
}
