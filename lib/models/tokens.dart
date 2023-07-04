import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:listen_together_app/services/spotify_auth.dart';

class AuthTokens {
  AuthTokens(this.spotifyTokens, this.userTokens);

  Map spotifyTokens = {"access_token": "", "refresh_token": ""};
  Map userTokens = {"access_token": "", "refresh_token": ""};

  Map spotifyTokenKeys = {
    "access_token": "spotify_access_token",
    "refresh_token": "spotify_refresh_token"
  };
  Map userTokenKeys = {
    "access_token": "user_acccess_token",
    "refresh_token": "user_refresh_token"
  };

  Future<void> saveToStorage({spotifyTokenValues, userTokenValues}) async {
    try {
      final storage = new FlutterSecureStorage();
      if (spotifyTokenValues) {
        await storage.write(
            key: spotifyTokenKeys['access_token'],
            value: spotifyTokenValues['access_token']);
        await storage.write(
            key: spotifyTokenKeys['refresh_token'],
            value: spotifyTokenValues['refresh_token']);
      }
      if (userTokenValues) {
        await storage.write(
            key: userTokenKeys['access_token'],
            value: userTokenValues['access_token']);
        await storage.write(
            key: userTokenKeys['refresh_token'],
            value: userTokenValues['refresh_token']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<AuthTokens?> readFromStorage() async {
    final storage = new FlutterSecureStorage();
    spotifyTokens['access_token'] =
        await storage.read(key: spotifyTokenKeys['access_token']);
    spotifyTokens['refresh_token'] =
        await storage.read(key: spotifyTokenKeys['refresh_token']);
    if (spotifyTokens['access_token'] == null ||
        spotifyTokens['refresh_token'] == null ||
        userTokens['access_token'] == null ||
        userTokens['refresh_token'] == null) return null;

    return AuthTokens(spotifyTokens, userTokens);
  }

  Future<void> clearStorage() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(
      key: spotifyTokenKeys['access_token'],
    );
    await storage.delete(
      key: spotifyTokenKeys['refresh_token'],
    );
    await storage.delete(
      key: userTokenKeys['access_token'],
    );
    await storage.delete(
      key: userTokenKeys['refresh_token'],
    );
  }

  Future<void> updateSpotifyTokens() async {
    final savedTokens = await readFromStorage();
    if (savedTokens == null) throw Exception("No saved token found");

    // final tokens =
    //     await SpotifyAuthApi.getNewTokens(originalTokens: savedTokens);
    final tokens = true;
    if (tokens) {
      await saveToStorage(spotifyTokenValues: tokens);
    }
  }
}
