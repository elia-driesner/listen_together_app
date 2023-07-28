import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:authentication/authentication.dart';
import 'package:listen_together_app/models/tokens.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'dart:io' show Platform;

import 'package:listen_together_app/pages/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import '/data/user_data.dart';
import 'package:listen_together_app/pages/auth/auth.dart';

import 'package:listen_together_app/services/user_prefrences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final passwordController = TextEditingController();
  final auth = Authentication();

  Widget? loadingIndicator;
  String errorMessage = "";

  void login({required String email, required String password}) async {
    errorMessage = "";

    if (email.length == 0) {
      errorMessage = "Please enter a valid email";
      setState(() => {errorMessage = errorMessage});
    } else if (password.length <= 5) {
      errorMessage = "Password too short";
      setState(() => {errorMessage = errorMessage});
    } else {
      if (Platform.isAndroid) {
        loadingIndicator = CircularProgressIndicator();
      } else {
        loadingIndicator = CupertinoActivityIndicator(radius: 18);
      }
      setState(() => {loadingIndicator});
      Map apiReturn = await auth.SignIn(email.toLowerCase(), password);
      if (apiReturn['error_message'] == '') {
        user_data = apiReturn['user_data'] as Map;
        user_data['password'] = password;
        jwt = apiReturn['tokens'];
        await SecureStorage.setUserData(user_data);
        await AuthTokens.saveToStorage(userTokenValues: jwt);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      } else {
        setState(() => {
              errorMessage = apiReturn['error_message'],
              loadingIndicator = null
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * 0.02), 0, 0),
              child: Center(
                  child: Text('Listen Together',
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize:
                              (MediaQuery.of(context).size.width * 0.06)))),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.8).toDouble(),
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      5, (MediaQuery.of(context).size.height * 0.09), 0, 0),
                  child: Text(
                    'To Login please enter your password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: (MediaQuery.of(context).size.width * 0.055)),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * 0.03), 0, 0),
              child: BigInput(
                size: [
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.1).toDouble()
                ],
                text: "Your Password",
                controller: passwordController,
              ),
            ),
            Spacer(),
            Column(
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(
                        0, 0, 0, (MediaQuery.of(context).size.height * 0.02)),
                    child: errorMessage != ''
                        ? Text('$errorMessage',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).errorColor,
                                fontSize: (MediaQuery.of(context).size.width *
                                    0.042)))
                        : Text('',
                            style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontSize: (MediaQuery.of(context).size.width *
                                    0.042)))),
                Container(
                    margin: EdgeInsets.fromLTRB(
                        0, 0, 0, MediaQuery.of(context).size.height * 0.035),
                    child: loadingIndicator == null
                        ? AccentButton(
                            [
                              (MediaQuery.of(context).size.width * 0.8)
                                  .toDouble(),
                              (MediaQuery.of(context).size.height * 0.062)
                                  .toDouble()
                            ],
                            'Login',
                            () => login(
                                email: 'admin@gmail.com',
                                password: passwordController.text),
                          )
                        : loadingIndicator),
              ],
            ),
          ],
        )));
  }
}
