import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import '/pages/houseparty/houseparty.dart';
import 'package:spotify_api/spotify_api.dart';
import 'package:listen_together_app/services/secure_storage.dart';

class StartPartyPage extends StatefulWidget {
  const StartPartyPage({super.key});

  @override
  State<StartPartyPage> createState() => _StartPartyPageState();
}

class _StartPartyPageState extends State<StartPartyPage> {
  void getPlayingSong() async {
    var _user_data = await SecureStorage.getUserData();
    var _tokens = await SecureStorage.getJWT();
    if (_user_data != null && _tokens != null) {
      var user_data = _user_data.userData['data'];
      String access_token = _tokens['user_tokens']['access_token'];
      SpotifyAPI.GetPlayingSong(
          user_data['username'], user_data['password'], access_token);
    }
  }

  void initState() {
    getPlayingSong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: AccentButton(
              [
                (MediaQuery.of(context).size.width * 0.8).toDouble(),
                (MediaQuery.of(context).size.height * 0.062).toDouble()
              ],
              'Start your Party',
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePartyPage(),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Center(
              child: AccentButton(
                [
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.062).toDouble()
                ],
                'Join a party',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePartyPage(),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Text(
                'Version 0.1 Beta. Die App ist noch lange nicht fertig, dies ist eine Test Version die nur wenige Leute erhalten',
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight, fontSize: 15),
              )),
        ],
      )),
    );
  }
}
