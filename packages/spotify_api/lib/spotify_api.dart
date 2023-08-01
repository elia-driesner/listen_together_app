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

  static Future<bool> SignIn(uid) async {
    var scope = 'user-read-private user-read-email';
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
}
