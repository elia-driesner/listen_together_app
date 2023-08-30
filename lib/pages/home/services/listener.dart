import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:listen_together_app/services/data/secure_storage.dart';
import 'package:authentication/authentication.dart';
import 'package:websockets/websockets.dart';

class SocketListener {
  static late Function setFadeColors;
  static late Function setLoadingIndicator;
  static late Function showSongData;
  static late Function removeSongData;
  static late Function setTitle;

  static Future<void> init(setFadeColorsFunc, setLoadingIndicatorFunc,
      showSongDataFunc, removeSongDataFunc, setTitleFunc) async {
    setFadeColors = setFadeColorsFunc;
    setLoadingIndicator = setLoadingIndicatorFunc;
    showSongData = showSongDataFunc;
    removeSongData = removeSongDataFunc;
    setTitle = setTitleFunc;
  }

  static void listen(username, tokens) {
    var channel = Websocket.channel;
    if (channel != null) {
      try {
        channel.sink.add(
            jsonEncode({"request": "start_song_loop", "username": username}));

        channel.stream.listen(
          (response) {
            response = json.decode(response);
            if (response['success'] == null) {
              if (response['item'] != null) {
                showSong(response);
              }
            }
          },
          onDone: () {
            setTitle('Loading');
            reconnect(username);
          },
        );
      } on Exception {
        setTitle('Loading');
        reconnect(username);
      }
    } else {
      reconnect(username);
    }
  }

  static Future<void> extractColors(songData) async {
    List<Color> colors = [];
    songData['item']['dominant_cover_colors'].forEach((var color) => {
          colors.add(Color.fromRGBO(color[0], color[1], color[2], 1)),
        });
    if (colors.isNotEmpty) {
      setFadeColors(colors);
    }
  }

  static void reconnect(username) async {
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
        try {
          await Websocket.renewConnection(tokens);
        } on Exception {
          var _tokens = await SecureStorage.getTokens();
          Map tokens = {};
          if (_tokens != null) {
            tokens = _tokens;
            await Websocket.renewConnection(tokens);
          }
        }
        listen(username, tokens);
      } else {
        Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  static void showSong(playingSong) async {
    setLoadingIndicator(false);
    showSongData(playingSong);
    extractColors(playingSong);
  }

  static void sheetListener(setModalState) {}
}
