import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserData {
  UserData(this.userData);

  Map userData;
  static String userDataKey = userDataKey;

  Future<void> saveToStorage(userData) async {
    try {
      final storage = new FlutterSecureStorage();
      await storage.write(key: userDataKey, value: userData);
    } catch (e) {
      print(e);
    }
  }

  static Future<UserData?> readFromStorage() async {
    final storage = new FlutterSecureStorage();
    Map userData;
    userData = await storage.read(key: userDataKey) as Map;
    if (userData == null) return null;

    return UserData(userData);
  }

  Future<void> clearStorage() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(
      key: userDataKey,
    );
  }

  Future<void> updateUserData() async {
    final savedTokens = await readFromStorage();
    if (savedTokens == null) throw Exception("No saved token found");

    // final tokens =
    //     await SpotifyAuthApi.getNewTokens(originalTokens: savedTokens);
    const tokens = true;
    if (tokens) {
      await saveToStorage(tokens);
    }
  }
}
