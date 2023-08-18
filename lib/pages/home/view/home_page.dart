import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listen_together_app/pages/listen_together/listen_together.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import 'package:listen_together_app/services/storage.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'package:listen_together_app/pages/settings/settings.dart';
import 'package:websockets/websockets.dart';
import 'package:web_socket_channel/status.dart' as status;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map song_data = {
    'cover': '',
    'title': 'Spotify not playing',
    'artist': '',
    'fade_colors': [
      Color.fromRGBO(0, 0, 0, 1),
      Color.fromRGBO(0, 0, 0, 1),
    ]
  };

  Future<void> extractColors() async {
    List<Color> colors = [];
    song_data['fade_colors'].forEach((var color) => {
          colors.add(Color.fromRGBO(color[0], color[1], color[2], 1)),
        });
    if (colors.length != 0) {
      setState(() => song_data['fade_colors'] = colors);
    } else {}
  }

  void update_song() async {
    var channel = Websocket.channel;
    channel.sink
        .add(jsonEncode({"request": "start_song_loop", "username": "Elia"}));
    channel.stream.listen((playing_song) {
      playing_song = json.decode(playing_song);
      if (playing_song['success'] == null) {
        setState(() {
          song_data['fade_colors'] =
              playing_song['item']['dominant_cover_colors'];
          if (playing_song['item']['is_local'] == false) {
            song_data['cover'] =
                playing_song['item']['album']['images'][1]['url'];
          }
          song_data['title'] = playing_song['item']['name'];
          song_data['artist'] = playing_song['item']['artist_names'];
        });
        extractColors();
      }
    });
  }

  void checkLogin(context) async {
    var user_data = await SecureStorage.getUserData();
    // debugPrint(user_data.toString());
    var _playing_song = await Storage.getData('playing_song');
    var playing_song;
    if (_playing_song != null) {
      playing_song = _playing_song;
      setState(() {
        user_data = user_data;

        song_data['fade_colors'] =
            playing_song['item']['dominant_cover_colors'];
        if (playing_song['item']['is_local'] == false) {
          song_data['cover'] =
              playing_song['item']['album']['images'][1]['url'];
        }
        song_data['title'] = playing_song['item']['name'];
        song_data['artist'] = playing_song['item']['artist_names'];
      });
      extractColors();
    } else {
      setState(() {
        user_data = user_data;
      });
    }
    update_song();
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
        body: Stack(
          children: [
            song_data['fade_colors'] != []
                ? Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: song_data['fade_colors'])))
                : Container(),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: IconButton(
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ),
                            )
                          },
                      icon: const Icon(
                        Icons.more_horiz,
                        size: 30,
                        color: Colors.grey,
                      )),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(width: MediaQuery.of(context).size.width),
                  const Spacer(),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, (MediaQuery.of(context).size.height * 0), 0, 0),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0, MediaQuery.of(context).size.width * 0.05, 0, 0),
                        child: SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.60),
                          height: (MediaQuery.of(context).size.width * 0.60),
                          child: song_data['cover'] != ''
                              ? Image.network(
                                  fit: BoxFit.cover,
                                  song_data['cover'].toString())
                              : Image.asset(
                                  fit: BoxFit.cover,
                                  'assets/icons/music_icon.png'),
                        ),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        song_data['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 30),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        song_data['artist'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 23),
                      )),
                  const Spacer(),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.width * 0.08),
                      child: Text(
                        'Listen with your Friends',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorLight,
                            fontSize: 29),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                      child: AccentButton(
                        [
                          (MediaQuery.of(context).size.width * 0.8).toDouble(),
                          (MediaQuery.of(context).size.height * 0.062)
                              .toDouble()
                        ],
                        'Start Listen Together',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartListenTogether(),
                          ),
                        ),
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.height * 0.03),
                      child: TransparentButton(
                          [
                            (MediaQuery.of(context).size.width * 0.8)
                                .toDouble(),
                            (MediaQuery.of(context).size.height * 0.062)
                                .toDouble()
                          ],
                          'Join Listen Together',
                          () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinListenTogether(),
                                ),
                              ))),
                ],
              ),
            ),
          ],
        ));
  }
}
