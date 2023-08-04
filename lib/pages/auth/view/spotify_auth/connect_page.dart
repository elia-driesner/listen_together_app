import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:authentication/authentication.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'package:spotify_api/spotify_api.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import 'package:listen_together_app/pages/home/home.dart';
import '/pages/auth/auth.dart';

class SpotifyConnectPage extends StatefulWidget {
  late String username;
  late String password;
  late String uid;
  SpotifyConnectPage(
      {super.key,
      required this.username,
      required this.password,
      required this.uid});

  @override
  State<SpotifyConnectPage> createState() => _SpotifyConnectPageState();
}

class _SpotifyConnectPageState extends State<SpotifyConnectPage> {
  String errorMessage = "";
  Widget? loadingIndicator;
  final auth = Authentication();

  void connectSpotify() async {
    if (Platform.isAndroid) {
      loadingIndicator = CircularProgressIndicator();
    } else {
      loadingIndicator = CupertinoActivityIndicator(radius: 18);
    }
    setState(() => {loadingIndicator});

    bool success = await SpotifyAPI.SignIn(widget.uid);
    if (success) {
      Future.delayed(const Duration(seconds: 1));
      Map apiReturn = await auth.SignIn(widget.username, widget.password);
      if (apiReturn['error_message'] == '') {
        var user_data = apiReturn['user_data'] as Map;
        user_data['data']['password'] = widget.password;
        await SecureStorage.setUserData(user_data);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      } else {
        setState(() {
          errorMessage = 'Something went wrong';
          loadingIndicator = null;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Something went wrong';
        loadingIndicator = null;
      });
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
            Spacer(),
            SizedBox(
              width: (MediaQuery.of(context).size.width * 0.8).toDouble(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, (MediaQuery.of(context).size.height * 0.3), 0, 0),
                      child: Text(
                        'Connect your',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize:
                                (MediaQuery.of(context).size.width * 0.09)),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, (MediaQuery.of(context).size.height * 0.0), 0, 0),
                      child: Text(
                        'Spotify Account',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color(0xff1db954),
                            fontSize:
                                (MediaQuery.of(context).size.width * 0.09)),
                      )),
                ],
              ),
            ),
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
                        0, 0, 0, MediaQuery.of(context).size.height * 0.05),
                    child: loadingIndicator == null
                        ? AccentButton(
                            [
                              (MediaQuery.of(context).size.width * 0.8)
                                  .toDouble(),
                              (MediaQuery.of(context).size.height * 0.062)
                                  .toDouble()
                            ],
                            'Connect Spotify',
                            () => connectSpotify(),
                          )
                        : loadingIndicator),
              ],
            ),
          ],
        )));
    ;
  }
}
