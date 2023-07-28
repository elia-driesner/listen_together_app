import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:authentication/authentication.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'dart:io' show Platform;

import 'package:listen_together_app/pages/auth/auth.dart';

class EmailPage extends StatefulWidget {
  EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final emailController = TextEditingController();
  final auth = Authentication();

  Widget? loadingIndicator;
  String errorMessage = "";

  void checkAccount(String email) async {
    if (email.length == 0) {
      errorMessage = "Please enter a valid email";
      setState(() => {errorMessage = errorMessage});
    } else {
      if (Platform.isAndroid) {
        loadingIndicator = CircularProgressIndicator();
      } else {
        loadingIndicator = CupertinoActivityIndicator(radius: 18);
      }
      errorMessage = '';
      setState(() => {loadingIndicator, errorMessage});
    }
    if (errorMessage == '') {
      String userExists = await auth.checkEmail(email);
      if (userExists == 'Server not found, try later again') {
        setState(() => {
              errorMessage = 'Server not found, try later again',
              loadingIndicator = null
            });
      } else if (userExists == 'User found') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => LoginPage(email: email)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegisterPage()));
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
                    'First off, please enter your email adress',
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
                text: "Your Email",
                controller: emailController,
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
                        ? AccentButton([
                            (MediaQuery.of(context).size.width * 0.8)
                                .toDouble(),
                            (MediaQuery.of(context).size.height * 0.062)
                                .toDouble()
                          ], 'Continue',
                            () => checkAccount(emailController.text))
                        : loadingIndicator),
              ],
            ),
          ],
        )));
  }
}


// change size dynamically on text