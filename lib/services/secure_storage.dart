import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listen_together_app/models/tokens.dart';
import 'package:listen_together_app/models/user.dart';
import 'package:listen_together_app/models/storage_keys.dart';

class SecureStorage {
  static late var _storage;

  static Future init() async => _storage = const FlutterSecureStorage();

  // Tokens

  static Future<Map?> getUserTokens() async {
    AuthTokens? tokens = await AuthTokens.readFromStorage();
    if (tokens != null) {
      Map userTokens = tokens.userTokens;
      return userTokens;
    } else {
      return null;
    }
  }

  static Future<Map?> getSpotifyTokens() async {
    AuthTokens? tokens = await AuthTokens.readFromStorage();
    if (tokens != null) {
      Map spotifyTokens = tokens.spotifyTokens;
      return spotifyTokens;
    } else {
      return null;
    }
  }

  static Future<AuthTokens?> getAuthTokens() async {
    return await AuthTokens.readFromStorage();
  }

  static Future<void> setTokens(spotifyTokens, userTokens) async {
    await AuthTokens.saveToStorage(
        spotifyTokenValues: spotifyTokens, userTokenValues: userTokens);
  }

  // User data

  static Future<UserData?> getUserData() async {
    return await UserData.readFromStorage();
  }

  static Future<void> setUserData(userData) async {
    await UserData.saveToStorage(userData);
  }
}

// TODO
// Add write to storage functions for tokens and user data
// Update login and register pages to write data using secure storage
// Make functions in login and register smaller

// if the data returns null always make one instance if secure storage and pass it to all functions
