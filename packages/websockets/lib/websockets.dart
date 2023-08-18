import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:listen_together_app/services/secure_storage.dart';

class Websocket {
  static String serverUrl = dotenv.env['WEBSOCKETS_URL'].toString();
  static String playingSongUrl = dotenv.env['PLAYING_SONG_URL'].toString();
  static var channel = WebSocketChannel.connect(
    Uri.parse(serverUrl + playingSongUrl),
  );

  static Future renewConnection() async {
    channel.sink.close();
    channel = WebSocketChannel.connect(
      Uri.parse(serverUrl + playingSongUrl),
    );
  }

  static void send(data) => channel.sink.add(data);

  static void disconnect() => channel.sink.close();
}
