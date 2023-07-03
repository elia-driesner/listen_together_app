import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:authentication/authentication.dart';
import 'package:listen_together_app/global_widgets/widgets.dart';
import '/data/user_data.dart';
import 'package:listen_together_app/pages/home/home.dart';

import 'package:listen_together_app/pages/auth/auth.dart';
import 'package:listen_together_app/pages/auth/utils/user_prefrences.dart';

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
      apiReturn = await auth.SignUp(email, password, username, uniqueName);
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
            child: Center(
          child: Column(children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        0, (MediaQuery.of(context).size.height * 0.0), 0, 0),
                    child: Center(
                        child: Image(
                      image: AssetImage('assets/icons/banner_placeholder.png'),
                      width: (MediaQuery.of(context).size.width * 1),
                    )),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 5, color: Theme.of(context).backgroundColor),
                      borderRadius: BorderRadius.circular(200),
                    ),
                    margin: EdgeInsets.fromLTRB(
                        0, (MediaQuery.of(context).size.height * 0.03), 0, 0),
                    child: const CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage('assets/icons/empty_profile_pic.png')),
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.001), 0, 0),
                child: GestureDetector(
                  onTap: () => {},
                  child: Text(
                    'Add Profile Picture',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: (MediaQuery.of(context).size.width * 0.042)),
                  ),
                )),
            Container(
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * 0.06), 0, 0),
              child: PrefixInputForm(
                size: [
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.06).toDouble()
                ],
                text: "Name",
                controller: uniqueNameController,
                obscureText: false,
                isPassword: false,
                prefixText: '@',
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
                text: "Username",
                controller: usernameController,
                obscureText: false,
                isPassword: false,
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
                text: "Birthday dd/mm/yyyy optional",
                controller: birthdayContoller,
                obscureText: false,
                isPassword: false,
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, (MediaQuery.of(context).size.height * 0.06), 0, 0),
                // ignore: prefer_if_null_operators
                child: loadingIndicator == null
                    ? WhiteButton(
                        [
                          (MediaQuery.of(context).size.width * 0.8).toDouble(),
                          (MediaQuery.of(context).size.height * 0.07).toDouble()
                        ],
                        'Create Account',
                        () => createAccount(
                            widget.email,
                            widget.password,
                            usernameController.text,
                            uniqueNameController.text,
                            birthdayContoller.text,
                            null,
                            null),
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
          ]),
        )));
  }
}
