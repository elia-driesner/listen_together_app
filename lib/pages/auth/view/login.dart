import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:authentication/authentication.dart';
import 'package:listen_together_app/global_widgets/widgets.dart';
import 'dart:io' show Platform;

import 'package:listen_together_app/pages/home/home.dart';
import '/data/user_data.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
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
        jwt = {
          'access': apiReturn['access'],
          'refresh': apiReturn['refresh'],
        };
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
                  0, (MediaQuery.of(context).size.height * 0.06), 0, 0),
              child: Center(
                  child: Image(
                      image: AssetImage('assets/icons/icon.png'),
                      width: (MediaQuery.of(context).size.width * 0.6),
                      height: (MediaQuery.of(context).size.height * 0.25))),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.02), 0, 0),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: (MediaQuery.of(context).size.width * 0.09)),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * 0.12), 0, 0),
              child: InputForm(
                size: [
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.06).toDouble()
                ],
                text: "Email",
                controller: emailController,
                obscureText: false,
                isPassword: false,
                prefixIcon: Icon(Icons.email_outlined,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * 0.02), 0, 0),
              child: InputForm(
                size: [
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.06).toDouble()
                ],
                text: "Password",
                controller: passwordController,
                obscureText: true,
                isPassword: true,
                prefixIcon: Icon(Icons.lock_outlined,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.04), 0, 0),
                child: loadingIndicator == null
                    ? WhiteButton(
                        [
                          (MediaQuery.of(context).size.width * 0.8).toDouble(),
                          (MediaQuery.of(context).size.height * 0.07).toDouble()
                        ],
                        'Login',
                        () => login(
                            email: emailController.text,
                            password: passwordController.text),
                      )
                    : loadingIndicator),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.02), 0, 0),
                child: errorMessage != ''
                    ? Text('$errorMessage',
                        style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize:
                                (MediaQuery.of(context).size.width * 0.042)))
                    : Text('',
                        style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize:
                                (MediaQuery.of(context).size.width * 0.042)))),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.01), 0, 0),
                child: Text('Forgot Password?',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize:
                            (MediaQuery.of(context).size.width * 0.042)))),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.003), 0, 0),
                child: Text(
                  'Dont have an Account?',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: (MediaQuery.of(context).size.width * 0.042)),
                ))
          ],
        )));
  }
}
