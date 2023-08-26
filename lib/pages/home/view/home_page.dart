import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listen_together_app/pages/listen_together/listen_together.dart';
import 'package:listen_together_app/services/data/secure_storage.dart';
import 'package:listen_together_app/services/data/storage.dart';
import 'package:listen_together_app/widgets/widgets.dart';
import 'package:listen_together_app/pages/settings/settings.dart';
import 'package:websockets/websockets.dart';
import 'package:authentication/authentication.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Map safeUserData;
  late Map safeTokens;
  Map song_data = {
    'cover': '',
    'title': 'Spotify not playing',
    'artist': '',
    'fade_colors': [
      const Color.fromRGBO(0, 0, 0, 1),
      const Color.fromRGBO(0, 0, 0, 1),
    ]
  };
  String errorMessage = '';
  Widget? loadingIndicator;
  bool stopListening = false;
  late StreamSubscription subscription;

  void navigationHandeler(page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    ).then((_) {
      updateSong(safeUserData['username'], safeTokens);
    });
  }

  void reconnect(username) async {
    if (Platform.isAndroid) {
      loadingIndicator = const CircularProgressIndicator();
    } else {
      loadingIndicator = const CupertinoActivityIndicator(radius: 18);
    }
    setState(() => {
          loadingIndicator,
          song_data['title'] = 'No Connection',
          song_data['artist'] = '',
          song_data['cover'] = '',
          song_data['fade_colors'] = [
            const Color.fromRGBO(0, 0, 0, 1),
            const Color.fromRGBO(0, 0, 0, 1),
          ]
        });
    bool tryAgain = true;
    var _tokens = await SecureStorage.getTokens();
    Map tokens = {};
    if (_tokens != null) {
      tokens = _tokens;
    }
    while (tryAgain) {
      var connection = await Authentication.checkConnection();
      if (connection == true) {
        tryAgain = false;
        await Websocket.renewConnection(tokens);
        setState(() => {song_data['title'] = 'Loading'});
        updateSong(username, tokens);
      } else {
        Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  Future<void> extractColors() async {
    List<Color> colors = [];
    song_data['fade_colors'].forEach((var color) => {
          colors.add(Color.fromRGBO(color[0], color[1], color[2], 1)),
        });
    if (colors.isNotEmpty) {
      setState(() => song_data['fade_colors'] = colors);
    }
  }

  void updateSong(username, tokens) async {
    setState(() => loadingIndicator = null);
    stopListening = false;
    var channel = Websocket.channel;
    if (channel != null) {
      try {
        Websocket.streamController.sink.add(
            jsonEncode({"request": "start_song_loop", "username": username}));
        Websocket.streamController.stream.listen(
          (playingSong) {
            if (stopListening == true) {
              subscription.cancel();
            } else {
              playingSong = json.decode(playingSong);
              if (playingSong['success'] == null) {
                setState(() {
                  song_data['fade_colors'] =
                      playingSong['item']['dominant_cover_colors'];
                  if (playingSong['item']['is_local'] == false) {
                    song_data['cover'] =
                        playingSong['item']['album']['images'][1]['url'];
                  } else {
                    song_data['cover'] = '';
                  }
                  song_data['title'] = playingSong['item']['name'];
                  song_data['artist'] = playingSong['item']['artist_names'];
                });
                extractColors();
              }
            }
          },
          onDone: () {
            if (stopListening == false) {
              reconnect(username);
            }
          },
        );
      } on Exception catch (e) {
        reconnect(username);
      }
    } else {
      reconnect(username);
    }
  }

  void checkLogin(context) async {
    var userData = await SecureStorage.getUserData();
    var _tokens = await SecureStorage.getTokens();
    Map tokens = {};
    if (_tokens != null) {
      tokens = _tokens;
      safeTokens = tokens;
    }
    if (userData != null) {
      safeUserData = userData;
    }
    // debugPrint(user_data.toString());
    var _playing_song = await Storage.getData('playing_song');
    var playingSong;
    if (_playing_song != null) {
      playingSong = _playing_song;
      setState(() {
        userData = userData;

        song_data['fade_colors'] = playingSong['item']['dominant_cover_colors'];
        if (playingSong['item']['is_local'] == false) {
          song_data['cover'] = playingSong['item']['album']['images'][1]['url'];
        }
        song_data['title'] = playingSong['item']['name'];
        song_data['artist'] = playingSong['item']['artist_names'];
      });
      extractColors();
    } else {
      if (userData != null) {
        setState(() {
          userData = userData;
        });
      }
    }
    await Websocket.renewConnection(tokens);
    updateSong(userData?['username'], tokens);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      stopListening = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLogin(context));
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      stopListening = true;
    });
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
                  margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
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
                    child: loadingIndicator == null
                        ? Container(
                            margin: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.width * 0.05, 0, 0),
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.width * 0.60),
                              height:
                                  (MediaQuery.of(context).size.width * 0.60),
                              child: song_data['cover'] != ''
                                  ? Image.network(
                                      fit: BoxFit.cover,
                                      song_data['cover'].toString())
                                  : Image.asset(
                                      fit: BoxFit.cover,
                                      'assets/icons/music_icon.png'),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(0,
                                MediaQuery.of(context).size.width * 0.05, 0, 0),
                            width: (MediaQuery.of(context).size.width * 0.60),
                            height: (MediaQuery.of(context).size.width * 0.60),
                            child: loadingIndicator),
                  ),
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
                          0,
                          MediaQuery.of(context).size.height * 0.05,
                          0,
                          MediaQuery.of(context).size.height * 0.02),
                      child: AccentButton(
                          [
                            (MediaQuery.of(context).size.width * 0.8)
                                .toDouble(),
                            (MediaQuery.of(context).size.height * 0.062)
                                .toDouble()
                          ],
                          'Start Listen Together',
                          () =>
                              navigationHandeler(const StartListenTogether()))),
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
                          () =>
                              navigationHandeler(const JoinListenTogether()))),
                ],
              ),
            ),
          ],
        ));
  }
}
