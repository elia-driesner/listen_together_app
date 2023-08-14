import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SpotifyAPI {
  static String client_id = dotenv.env['SPOTIFY_CLIENT_ID'].toString();
  static var redirect_uri = dotenv.env['SPOTIFY_REDIRECT_URL'].toString();
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
    String server_url = dotenv.env['SERVER_URL'].toString();
    String url = '${server_url}api/playback/playing_song/';
    try {
      String encodedBody =
          jsonEncode({"password": password, "username": username});
      var playing_song = await client.post(Uri.parse(url),
          body: encodedBody,
          headers: {"Authorization": "Bearer " + access_token});
      var dec_playing_song = jsonDecode(utf8.decode(playing_song.bodyBytes));
      return {'data': dec_playing_song, 'error_message': '', 'success': true};
    } on Exception catch (_) {
      return {'error_message': 'No connection to Spotify', 'success': false};
    }
  }
}
