import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listen_together_app/services/spotify_auth.dart';
import 'package:listen_together_app/models/storage_keys.dart';

class AuthTokens {
  AuthTokens(this.spotifyTokens, this.userTokens);

  Map spotifyTokens;
  Map userTokens;
  static var _storage;
  static Map spotifyTokenKeys = {
    "access_token": "spotify_access_token",
    "refresh_token": "spotify_refresh_token"
  };
  static Map userTokenKeys = {
    "access_token": "user_acccess_token",
    "refresh_token": "user_refresh_token"
  };

  static Future init(storage) async => _storage = storage;

  static Future<void> saveToStorage(
      {spotifyTokenValues, userTokenValues}) async {
    try {
      if (spotifyTokenValues != null) {
        await _storage.write(
            key: spotifyTokenKeys['access_token'],
            value: spotifyTokenValues['access_token']);
        await _storage.write(
            key: spotifyTokenKeys['refresh_token'],
            value: spotifyTokenValues['refresh_token']);
      }

      if (userTokenValues != null) {
        await _storage.write(
            key: userTokenKeys['access_token'],
            value: userTokenValues['access_token']);
        await _storage.write(
            key: userTokenKeys['refresh_token'],
            value: userTokenValues['refresh_token']);
      }
    } catch (e) {
      debugPrint('token write exception:');
      print(e);
    }
  }

  static Future<AuthTokens?> readFromStorage() async {
    Map spotifyTokens = {};
    Map userTokens = {};
    spotifyTokens['access_token'] =
        await _storage.read(key: spotifyTokenKeys['access_token']);
    spotifyTokens['refresh_token'] =
        await _storage.read(key: spotifyTokenKeys['refresh_token']);
    userTokens['access_token'] =
        await _storage.read(key: userTokenKeys['access_token']);
    userTokens['refresh_token'] =
        await _storage.read(key: userTokenKeys['refresh_token']);
    if (spotifyTokens['access_token'] == null ||
        spotifyTokens['refresh_token'] == null ||
        userTokens['access_token'] == null ||
        userTokens['refresh_token'] == null) return null;

    return AuthTokens(spotifyTokens, userTokens);
  }

  static Future<Map?> readJWT() async {
    Map userTokens = {};
    userTokens['access_token'] =
        await _storage.read(key: userTokenKeys['access_token']);
    userTokens['refresh_token'] =
        await _storage.read(key: userTokenKeys['refresh_token']);
    debugPrint(userTokens.toString());
    if (userTokens['access_token'] == null ||
        userTokens['refresh_token'] == null) return null;

    return {'user_tokens': userTokens};
  }

  static Future<void> clearStorage() async {
    await _storage.delete(
      key: spotifyTokenKeys['access_token'],
    );
    await _storage.delete(
      key: spotifyTokenKeys['refresh_token'],
    );
    await _storage.delete(
      key: userTokenKeys['access_token'],
    );
    await _storage.delete(
      key: userTokenKeys['refresh_token'],
    );
  }

  Future<void> updateSpotifyTokens() async {
    final savedTokens = await readFromStorage();
    if (savedTokens == null) throw Exception("No saved token found");

    // final tokens =
    //     await SpotifyAuthApi.getNewTokens(originalTokens: savedTokens);
    const tokens = true;
    if (tokens) {
      await saveToStorage(spotifyTokenValues: tokens);
    }
  }
}
