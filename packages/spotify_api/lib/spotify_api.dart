import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SpotifyAPI {
  static String client_id = '73b15a242eaa4132a448cffe09997787';
  static var redirect_uri = 'http://127.0.0.1:8000/api/db/callback';
  static Map<String, dynamic> url_map = {
    'login': 'https://accounts.spotify.com/authorize?'
  };
  static var client = http.Client();

  static Future<bool> SignIn(uid) async {
    var scope =
        'user-read-private user-read-playback-state user-modify-playback-state user-read-currently-playing app-remote-control';
    final params = {
      'client_id': client_id,
      'scope': scope,
      'redirect_uri': redirect_uri,
      'state': uid,
      'response_type': 'code',
    };

    final Uri url = Uri.http('accounts.spotify.com', 'authorize', params);
    var resp = await launchUrl(url);
    return resp;
  }

  static Future<Map> GetPlayingSong(username, password, access_token) async {
    const String url = 'http://127.0.0.1:8000/api/playback/playing_song/';
    String encodedBody =
        jsonEncode({"password": "123456", "username": "Elia Driesner"});
    var playing_song =
        await client.post(Uri.parse(url), body: encodedBody, headers: {
      "Authorization":
          "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkxMzU3OTc5LCJpYXQiOjE2OTEzNTE1NTUsImp0aSI6ImE3ZjMzMmI0MGNiNDQyODFhMjliYmI4MWY5MmI2NTJjIiwidXNlcl9pZCI6NX0.fSCSHRzjbHTCa8tQHBpLtvLq1XB_pfPUJXzsTdq-Hg4"
    });
    var dec_playing_song = jsonDecode(utf8.decode(playing_song.bodyBytes));
    debugPrint(dec_playing_song.toString());
    return {'data': 'data'};
  }
}
