import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:listen_together_app/services/secure_storage.dart';

class Websocket {
  static String serverApiUrl = dotenv.env['SERVER_URL'].toString();
  static String serverUrl = dotenv.env['WEBSOCKETS_URL'].toString();
  static String playingSongUrl = dotenv.env['PLAYING_SONG_URL'].toString();
  static var channel;

  static Future<String> getTicket(access_token) async {
    var userDataResp = await http.post(
      Uri.parse('${serverApiUrl}api/playback/get_ticket/'),
      headers: {"Authorization": "Bearer " + access_token},
    );
    Map decodedUserData = jsonDecode(utf8.decode(userDataResp.bodyBytes));
    if (decodedUserData['success'] == true) {
      return decodedUserData['data'];
    } else {
      return decodedUserData['error'];
    }
  }

  static Future renewConnection(access_token) async {
    if (channel != null) channel.sink.close();
    String ticket = await getTicket(access_token);
    channel = await WebSocketChannel.connect(
      Uri.parse(serverUrl + playingSongUrl + '?ticket=' + ticket),
    );
  }

  static void send(data) => channel.sink.add(data);

  static void disconnect() => channel.sink.close();
}
