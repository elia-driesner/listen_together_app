import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listen_together_app/models/tokens.dart';
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

  Future<AuthTokens?> getAuthTokens() async {
    return await AuthTokens.readFromStorage();
  }

  // User data

  Future<AuthTokens?> getUserData() async {
    return await _storage.read(key: userDataKey);
  }
}
