import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Authentication {
  var serverUrl = 'http://127.0.0.1:8000/';
  String errorMessage = '';

  Future<Map> SignIn(email, password) async {
    var client = http.Client();
    var decodedToken;
    var decodedUserData;
    var errorMessage = '';
    try {
      var serverResp = await client.get(
        Uri.parse(serverUrl),
      );
    } on Exception catch (_) {
      errorMessage = 'Server not found, try later again';
    }
    if (errorMessage == 'Server not found, try later again') {
      return {'error_message': errorMessage};
    }
    try {
      var tokenResp = await client.post(Uri.parse(serverUrl + 'api/token/'),
          body: {'email': email, 'password': password});
      decodedToken = jsonDecode(utf8.decode(tokenResp.bodyBytes)) as Map;
      if (decodedToken['access'] != null) {
        var userDataResp = await client.post(
          Uri.parse('${serverUrl}api/db/login/'),
          headers: {"Authorization": "Bearer " + decodedToken["access"]},
          body: json.encode({'email': email, 'password': password}),
        );
        decodedUserData =
            jsonDecode(utf8.decode(userDataResp.bodyBytes)) as Map;
        decodedUserData['password'] = 'hidden';
      } else if (decodedToken['detail'] ==
          'No active account found with the given credentials') {
        var validationResp = await client
            .get(Uri.parse('${serverUrl}api/db/emailExists/' + email));
        var decodedValidation =
            jsonDecode(utf8.decode(validationResp.bodyBytes)) as Map;
        if (decodedValidation['detail'] == 'User found') {
          errorMessage = 'Wrong password';
        } else {
          errorMessage = 'User not found';
        }
      }
    } finally {
      client.close();
    }
    if (errorMessage == '') {
      return {
        'error_message': '',
        'tokens': decodedToken,
        'user_data': decodedUserData,
      };
    } else {
      return {'error_message': errorMessage};
    }
  }

  Future<Map> SignUp(email, password, username, unique_name) async {
    email = email.toLowerCase();
    var client = http.Client();
    var errorMessage = '';
    var createUserRequest;
    var decodedUserRequest;
    var tokenRequest;
    var decodedToken = {};
    try {
      var serverResp = await client.get(
        Uri.parse(serverUrl),
      );
    } on Exception catch (_) {
      errorMessage = 'Server not found, try later again';
    }
    if (errorMessage == 'Server not found, try later again') {
      return {'error_message': errorMessage};
    }
    try {
      var body = {
        "email": email,
        "password": password,
        "username": username,
        "unique_name": unique_name
      };
      String encodedBody = jsonEncode(body);
      createUserRequest = await client
          .post(Uri.parse(serverUrl + 'api/db/createUser/'), body: encodedBody);
      debugPrint(createUserRequest.body);
      decodedUserRequest =
          jsonDecode(utf8.decode(createUserRequest.bodyBytes)) as Map;
      if (decodedUserRequest['error'] == '') {
        await Future.delayed(const Duration(seconds: 1));
        int iteration = 0;
        while (decodedToken['access'] == null) {
          if (iteration == 20) {
            errorMessage = 'Server timeout';
            break;
          }
          iteration++;
          tokenRequest = await client.post(Uri.parse(serverUrl + 'api/token/'),
              body: {'email': email, 'password': password});
          decodedToken = jsonDecode(utf8.decode(tokenRequest.bodyBytes)) as Map;
          debugPrint(decodedToken.toString());
          await Future.delayed(const Duration(seconds: 1));
        }
        return {
          'error_message': '',
          'user_data': decodedUserRequest['user'],
          'tokens': decodedToken
        };
      } else {
        return {'error_message': decodedUserRequest['error']};
      }
    } finally {
      client.close();
    }
  }

  Future<String> checkEmail(email) async {
    var client = http.Client();
    var validationResp;
    var decodedValidation;
    try {
      validationResp = await client
          .get(Uri.parse('${serverUrl}api/db/emailExists/' + email));
      decodedValidation =
          jsonDecode(utf8.decode(validationResp.bodyBytes)) as Map;
      if (decodedValidation['detail'] == 'User found') {
        return ('User found');
      } else {
        return ('User not found');
      }
    } finally {
      client.close();
    }
  }

  void ChangePassword(email, password) {}
  void DeleteAcc(email, password) {}
}
