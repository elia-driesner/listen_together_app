import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:listen_together_app/services/secure_storage.dart';

class Authentication {
  static var serverUrl = 'http://127.0.0.1:8000/';
  static String errorMessage = '';

  static Future<Map> SignIn(username, password) async {
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
          body: {'username': username, 'password': password});
      decodedToken = jsonDecode(utf8.decode(tokenResp.bodyBytes)) as Map;
      if (decodedToken['access'] != null) {
        var userDataResp = await client.post(
          Uri.parse('${serverUrl}api/db/login/'),
          headers: {"Authorization": "Bearer " + decodedToken["access"]},
          body: json.encode({'username': username, 'password': password}),
        );
        decodedUserData =
            jsonDecode(utf8.decode(userDataResp.bodyBytes)) as Map;
        decodedUserData['password'] = password;
      } else if (decodedToken['detail'] ==
          'No active account found with the given credentials') {
        var validationResp = await client
            .get(Uri.parse('${serverUrl}api/db/userExists/' + username));
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

  static Future<Map> SignUp(username, password) async {
    username = username;
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
        "username": username,
        "password": password,
      };
      String encodedBody = jsonEncode(body);
      createUserRequest = await client
          .post(Uri.parse(serverUrl + 'api/db/register/'), body: encodedBody);
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
              body: {'username': username, 'password': password});
          decodedToken = jsonDecode(utf8.decode(tokenRequest.bodyBytes)) as Map;
          await Future.delayed(const Duration(seconds: 1));
        }
        return {
          'error_message': '',
          'user_data': decodedUserRequest,
          'tokens': decodedToken
        };
      } else {
        return {'error_message': decodedUserRequest['error']};
      }
    } finally {
      client.close();
    }
  }

  static Future<String> checkUsername(username) async {
    var client = http.Client();
    var validationResp;
    var decodedValidation;
    try {
      try {
        validationResp = await client
            .get(Uri.parse('${serverUrl}api/db/userExists/' + username));
      } on Exception catch (_) {
        errorMessage = 'Server not found, try later again';
      }
      if (errorMessage == 'Server not found, try later again') {
        return errorMessage;
      }
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

  // static Future<Map> RenewTokens(refresh_token) async {
  //   var client = http.Client();
  //   var access_token = await client.post(
  //       Uri.parse(serverUrl + 'api/token/refresh/'),
  //       body: {'refresh': refresh_token});
  //   var decoded_access_token =
  //       jsonDecode(utf8.decode(access_token.bodyBytes)) as Map;
  //   debugPrint({
  //     'access_token': decoded_access_token,
  //     'refresh_token': refresh_token
  //   }.toString());
  //   return {
  //     'access_token': decoded_access_token,
  //     'refresh_token': refresh_token
  //   };
  // }

  static Future<Map> RenewData(user_data, refresh_token) async {
    var client = http.Client();
    if (await checkConnection(client: client)) {
      var access_token = await client.post(
          Uri.parse(serverUrl + 'api/token/refresh/'),
          body: {'refresh': refresh_token});
      var decoded_access_token =
          jsonDecode(utf8.decode(access_token.bodyBytes));
      decoded_access_token = decoded_access_token['access'];
      Map<String, String> tokens = {
        'access_token': decoded_access_token,
        'refresh_token': refresh_token
      };
      var userDataResp = await client.post(
        Uri.parse('${serverUrl}api/db/login/'),
        headers: {"Authorization": "Bearer " + decoded_access_token},
        body: json.encode({
          'username': user_data['username'],
          'password': user_data['password']
        }),
      );
      Map decodedUserData = jsonDecode(utf8.decode(userDataResp.bodyBytes));
      decodedUserData = decodedUserData;
      decodedUserData['data']['password'] = user_data['password'];
      return {
        'error_message': '',
        'success': true,
        'user_data': decodedUserData,
        'tokens': tokens
      };
    } else {
      return {'error_message': 'No Connection', 'success': false};
    }
  }

  static Future<bool> checkConnection({client = null}) async {
    bool dropClient = false;
    if (client == null) {
      client = http.Client();
      dropClient = true;
    }
    try {
      var serverResp = await client.get(
        Uri.parse(serverUrl),
      );
    } on Exception catch (_) {
      if (dropClient) {
        client.close();
      }
      return (false);
    }
    if (dropClient) {
      client.close();
    }
    return (true);
  }

  void ChangePassword(username, password) {}
  void DeleteAcc(username, password) {}
}
