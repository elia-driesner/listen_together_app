import 'package:flutter/material.dart';
import 'package:listen_together_app/pages/listen_together/view/start_listen_together.dart';
import 'package:listen_together_app/services/secure_storage.dart';
import 'package:listen_together_app/services/storage.dart';
import 'package:listen_together_app/widgets/widgets.dart';

import 'package:listen_together_app/pages/listen_together/listen_together.dart';

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
    'dominant_colors': []
  };

  void checkLogin(context) async {
    var user_data = await SecureStorage.getUserData();
    // debugPrint(user_data.toString());
    var _playing_song = await Storage.getData('playing_song');
    await Storage.deleteData('playing_song');
    var playing_song;
    if (_playing_song != null) {
      playing_song = _playing_song;
    }
    setState(() {
      user_data = user_data;

      song_data['dominant_colors'] =
          playing_song['item']['dominant_cover_colors'];
      song_data['cover'] = playing_song['item']['album']['images'][1]['url'];
      song_data['title'] = playing_song['item']['name'];
      song_data['artist'] = playing_song['item']['artist_names'];
    });
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
        body: SafeArea(
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
                    width: (MediaQuery.of(context).size.width * 0.55),
                    height: (MediaQuery.of(context).size.width * 0.55),
                    child: song_data['cover'] != ''
                        ? Image.network(
                            fit: BoxFit.cover, song_data['cover'].toString())
                        : Image.asset(
                            fit: BoxFit.cover, 'assets/icons/music_icon.png'),
                  ),
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  song_data['title'],
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 30),
                )),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  song_data['artist'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 23),
                )),
            const Spacer(),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).size.width * 0.08),
                child: Text(
                  'Listen with your Friends',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 29),
                )),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).size.height * 0.02),
                child: AccentButton(
                  [
                    (MediaQuery.of(context).size.width * 0.8).toDouble(),
                    (MediaQuery.of(context).size.height * 0.062).toDouble()
                  ],
                  'Start Listen Together',
                  () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StartListenTogether(),
                      ),
                    )
                  },
                )),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).size.height * 0.03),
                child: TransparentButton([
                  (MediaQuery.of(context).size.width * 0.8).toDouble(),
                  (MediaQuery.of(context).size.height * 0.062).toDouble()
                ], 'Join Listen Together', () => {})),
          ],
        )));
  }
}
