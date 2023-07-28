import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:authentication/authentication.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import '/data/user_data.dart';
import 'package:listen_together_app/pages/home/home.dart';

import 'package:listen_together_app/pages/auth/auth.dart';
import 'package:listen_together_app/services/user_prefrences.dart';

class CreateAccPage extends StatefulWidget {
  CreateAccPage({super.key, required this.email, required this.password});
  String email;
  String password;

  @override
  State<CreateAccPage> createState() => _CreateAccPageState();
}

class _CreateAccPageState extends State<CreateAccPage> {
  final usernameController = TextEditingController();
  final uniqueNameController = TextEditingController();
  final birthdayContoller = TextEditingController();

  var profilePicture;

  var banner;

  String errorMessage = "";
  final auth = Authentication();

  var characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_1234567890';

  Widget? loadingIndicator;

  void createAccount(email, password, username, uniqueName, birthday,
      profilePicture, banner) async {
    errorMessage = "";
    Map apiReturn = {};
    uniqueName.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      if (characters.contains(character)) {
      } else {
        setState(() {
          errorMessage = 'The name cant contain symbols';
        });
      }
    });
    if (errorMessage == "") {
      if (Platform.isAndroid) {
        loadingIndicator = CircularProgressIndicator();
      } else {
        loadingIndicator = CupertinoActivityIndicator(radius: 18);
      }
      setState(() => {loadingIndicator});
      uniqueName = '@$uniqueName';
      apiReturn = await auth.SignUp(email, password);
      if (apiReturn['error_message'] == '') {
        user_data = apiReturn['user_data'] as Map;
        jwt = apiReturn['tokens'];
        await UserSimplePreferences.setUserData(user_data);
        await UserSimplePreferences.setTokens(jwt);
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
          child: Center(child: Text('create account')),
        ));
  }
}
