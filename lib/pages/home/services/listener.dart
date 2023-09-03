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
  static late Function showLoading;
  static late Function setRoomWidgets;

  static late Function showError;
  static late Function moveNameBack;
  static late Function setModalState;
  static late Function closeSheet;

  static Future<void> initHome(setFadeColorsFunc, setLoadingIndicatorFunc,
      showSongDataFunc, removeSongDataFunc, setRoomWidgetsFunc) async {
    setFadeColors = setFadeColorsFunc;
    setLoadingIndicator = setLoadingIndicatorFunc;
    showSongData = showSongDataFunc;
    removeSongData = removeSongDataFunc;
    setRoomWidgets = setRoomWidgetsFunc;
  }

  static Future<void> initSheet(showErrorFunc, moveNameBackFunc,
      setModalStateFunc, closeSheetFunc) async {
    showError = showErrorFunc;
    moveNameBack = moveNameBackFunc;
    setModalState = setModalStateFunc;
    closeSheet = closeSheetFunc;
  }

  static void listen(username, tokens) {
    var channel = Websocket.channel;
    if (channel != null) {
      try {
        channel.sink.add(jsonEncode({"request": "start_song_loop"}));

        channel.stream.listen(
          (response) {
            response = json.decode(response);
            debugPrint(response.toString());
            if (response['success'] == true) {
              if (response['code'] == 'playing_song') {
                if (response['detail'] != 'not_playing') {
                  showSong(response['data']);
                } else {
                  removeSongData('Spotify not playing');
                }
              } else if (response['code'] == 'response') {
                if (response['detail'] == 'listen_together_started') {
                  showSheetCallback(response);
                }
                if (response['detail'] == 'joined') {
                  showSheetCallback(response);
                }
              }
            } else {
              if (response['code'] == 'response') {
                if (response['error'] == 'invalid_room_id') {
                  showSheetCallback(response);
                } else if (response['detail'] == 'room_doesnt_exist') {
                  showSheetCallback(response);
                }
              }
            }
          },
          onDone: () {
            removeSongData();
            reconnect(username);
          },
        );
      } on Exception {
        removeSongData();
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

  static Future<void> leaveRoom() async {
    Websocket.channel.sink
        .add(jsonEncode({"request": "leave_listen_together"}));
  }

  static void reconnect(username) async {
    bool tryAgain = true;
    var _tokens = await SecureStorage.getTokens();
    Map tokens = {};
    if (_tokens != null) {
      tokens = _tokens;
    }
    while (tryAgain) {
      debugPrint('reconnect');
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
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  static void showSong(playingSong) async {
    setLoadingIndicator(false);
    showSongData(playingSong);
    extractColors(playingSong);
  }

  static void showSheetCallback(callback) {
    moveNameBack(setModalState);
    if (callback['error'] == 'invalid_room_id') {
      if (callback['detail'] == 'start') {
        showError(setModalState, 'ID already exists');
      } else {
        showError(setModalState, 'Please try later again');
      }
    } else if (callback['detail'] == 'room_doesnt_exist') {
      showError(setModalState, 'ID doesnt exist');
    } else if (callback['detail'] == 'listen_together_started' ||
        callback['detail'] == 'joined') {
      setRoomWidgets();
      showError(setModalState, '');
      closeSheet();
    }
  }
}
