import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpotifyAPI {
  static String client_id = '73b15a242eaa4132a448cffe09997787';
  static var redirect_uri = 'https://elia-driesner.github.io/';
  static Map<String, String> url_map = {
    'login': 'https://accounts.spotify.com/authorize?'
  };

  static Future<void> SignIn() async {}
}
