import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication {
  var server_url = 'http://127.0.0.1:8000/api/';
  String error_message = '';

  Future<Map> SignIn(email, password) async {
    var client = http.Client();
    var decodedToken;
    var decodedUserData;
    var error_message = '';
    try {
      var tokenResp = await client.post(Uri.parse(server_url + 'token/'),
          body: {'email': email, 'password': password});
      decodedToken = jsonDecode(utf8.decode(tokenResp.bodyBytes)) as Map;
      if (decodedToken['access'] != null) {
        var userDataResp = await client.get(
            Uri.parse(server_url + 'db/getuser/' + email),
            headers: {'Authorization': 'Bearer ' + decodedToken['access']});
        decodedUserData =
            jsonDecode(utf8.decode(userDataResp.bodyBytes)) as Map;
        decodedUserData['password'] = 'hidden';
      } else if (decodedToken['detail'] ==
          'No active account found with the given credentials') {
        var validationResp =
            await client.get(Uri.parse(server_url + 'db/emailExists/' + email));
        var decodedValidation =
            jsonDecode(utf8.decode(validationResp.bodyBytes)) as Map;
        if (decodedValidation['detail'] == 'User found') {
          error_message = 'Wrong password';
        } else {
          error_message = 'User not found';
        }
        debugPrint(error_message);
      }
    } finally {
      client.close();
    }
    if (error_message == '') {
      return {
        'error_message': '',
        'tokens': decodedToken,
        'user_data': decodedUserData,
      };
    } else {
      return {'error_message': error_message};
    }
  }

  void SignUp(email, password) {}
  void ChangePassword(email, password) {}
  void DeleteAcc(email, password) {}
}
