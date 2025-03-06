import 'package:shared_preferences/shared_preferences.dart';

class UserIdStorage {
  static Future<void> saveLoggedInUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loggedInUserId', userId);
  }

  static Future<int?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserId');
  }

  static Future<void> setRememberMe(bool b) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', b);
  }

  static Future<bool?> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe');
  }
}
