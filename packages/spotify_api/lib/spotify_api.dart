import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SpotifyAPI {
  static String client_id = '73b15a242eaa4132a448cffe09997787';
  static var redirect_uri = 'https://elia-driesner.github.io/';
  static Map<String, dynamic> url_map = {
    'login': 'https://accounts.spotify.com/authorize?'
  };

  static Future<void> SignIn() async {
    var state = 'qwertzuiopasdfgh';
    var scope = 'user-read-private user-read-email';
    final params = {
      'client_id': client_id,
      'scope': scope,
      'redirect_uri': redirect_uri,
      'state': state,
      'response_type': 'code',
    };

    final Uri url = Uri.http('accounts.spotify.com', 'authorize', params);
    var resp = await launchUrl(url);
    debugPrint(resp.toString());
  }
}
