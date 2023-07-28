import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:authentication/authentication.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'dart:io' show Platform;

import 'package:listen_together_app/pages/home/home.dart';
import '/data/user_data.dart';
import 'package:listen_together_app/pages/auth/auth.dart';

class OldRegisterPage extends StatefulWidget {
  OldRegisterPage({super.key});

  @override
  State<OldRegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<OldRegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmationPasswordController = TextEditingController();
  final auth = Authentication();

  Widget? loadingIndicator;
  String errorMessage = "";

  void confirmEmail(
      {required String email,
      required String password,
      required String confirmationPassword}) async {
    errorMessage = "";
    if (password.length <= 5 || confirmationPassword.length <= 5) {
      errorMessage = "Password is too short";
      setState(() => {errorMessage = errorMessage});
    } else if (password != confirmationPassword) {
      errorMessage = "Passwords do not match";
      setState(() => {errorMessage = errorMessage});
    }
    if (email.length == 0) {
      errorMessage = "Please enter a valid email";
      setState(() => {errorMessage = errorMessage});
    }
    if (errorMessage == '') {
      if (Platform.isAndroid) {
        loadingIndicator = CircularProgressIndicator();
      } else {
        loadingIndicator = CupertinoActivityIndicator(radius: 18);
      }
      setState(() => {loadingIndicator});
      String emailValidation = await auth.checkEmail(email.toLowerCase());
      if (emailValidation == 'User found') {
        setState(() =>
            {errorMessage = 'Account already exists', loadingIndicator = null});
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CreateAccPage(email: email, password: password),
          ),
        );
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
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.8).toDouble(),
              child: Container(
                  margin: EdgeInsets.fromLTRB(
                      5, (MediaQuery.of(context).size.height * 0.02), 0, 0),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: (MediaQuery.of(context).size.width * 0.09)),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * 0.02), 0, 0),
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
                  0, (MediaQuery.of(context).size.height * 0.02), 0, 0),
              child: InputForm(
                size: [
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.06).toDouble()
                ],
                text: "Confirm Password",
                controller: confirmationPasswordController,
                obscureText: true,
                isPassword: true,
                prefixIcon: Icon(Icons.lock_outlined,
                    color: Theme.of(context).primaryColorDark),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.03), 0, 0),
                child: loadingIndicator == null
                    ? AccentButton(
                        [
                          (MediaQuery.of(context).size.width * 0.8).toDouble(),
                          (MediaQuery.of(context).size.height * 0.062)
                              .toDouble()
                        ],
                        'Continue',
                        () => confirmEmail(
                            email: emailController.text,
                            password: passwordController.text,
                            confirmationPassword:
                                confirmationPasswordController.text),
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
                    0, (MediaQuery.of(context).size.height * 0.04), 0, 0),
                child: GestureDetector(
                    onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailPage(),
                            ),
                          )
                        },
                    child: Text(
                      'Already have an Account? Sign In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorLight,
                          fontSize:
                              (MediaQuery.of(context).size.width * 0.042)),
                    )))
          ],
        )));
  }
}
