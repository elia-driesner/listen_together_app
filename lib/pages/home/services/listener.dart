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
        setTitle('Loading');
        homeListener(username, tokens);
      } else {
        Future.delayed(const Duration(milliseconds: 200));
      }
    }
  }

  static void homeListener(username, tokens) async {
    setLoadingIndicator(false);
    await Websocket.renewConnection(tokens);
    var channel = Websocket.channel;
    if (channel != null) {
      try {
        channel.sink.add(
            jsonEncode({"request": "start_song_loop", "username": username}));
        channel.stream.listen(
          (playingSong) {
            playingSong = json.decode(playingSong);
            if (playingSong['success'] == null) {
              showSongData(playingSong);
              extractColors(playingSong);
            }
          },
          onDone: () {
            reconnect(username);
          },
        );
      } on Exception {
        reconnect(username);
      }
    } else {
      reconnect(username);
    }
  }

  static void sheetListener(setModalState) {}
}
