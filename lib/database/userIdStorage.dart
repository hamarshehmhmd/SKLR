import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class UserIdStorage {
  static const String _userIdKey = 'user_id';
  static dynamic _cachedUserId;

  // Save the logged-in user ID (handles both int and String IDs)
  static Future<bool> saveLoggedInUserId(dynamic userId) async {
    try {
      // Clear the cache first
      _cachedUserId = null;
      
      if (userId == null) {
        log('Attempted to save null userId, clearing instead');
        return await clearLoggedInUserId();
      }
      
      // Convert to string for storage
      final String userIdStr = userId.toString();
      log('Saving user ID to storage: $userIdStr');
      
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setString(_userIdKey, userIdStr);
      
      if (result) {
        // Update cache on successful save
        _cachedUserId = userId;
        log('Successfully saved user ID: $userIdStr');
      } else {
        log('Failed to save user ID to SharedPreferences');
      }
      
      return result;
    } catch (e) {
      log('Error saving user ID: $e');
      return false;
    }
  }

  // Get the logged-in user ID
  static Future<dynamic> getLoggedInUserId() async {
    try {
      // Return from cache if available
      if (_cachedUserId != null) {
        return _cachedUserId;
      }
      
      final prefs = await SharedPreferences.getInstance();
      final String? userIdStr = prefs.getString(_userIdKey);
      
      if (userIdStr == null || userIdStr.isEmpty) {
        log('No user ID found in storage');
        return null;
      }
      
      log('Retrieved user ID from storage: $userIdStr');
      
      // Try to convert to integer if possible
      try {
        final int userId = int.parse(userIdStr);
        _cachedUserId = userId; // Cache the result
        return userId;
      } catch (e) {
        // If not an integer, return as string
        _cachedUserId = userIdStr; // Cache the result
        return userIdStr;
      }
    } catch (e) {
      log('Error retrieving user ID: $e');
      return null;
    }
  }

  static Future<void> setRememberMe(bool b) async {
    final prefs = await SharedPreferences.getInstance();
    log('Setting remember me: $b');
    await prefs.setBool('rememberMe', b);
  }

  static Future<void> saveRememberMe(bool b) async {
    await setRememberMe(b);
  }

  static Future<bool?> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('rememberMe');
    log('Retrieved remember me: $value');
    return value;
  }

  // Clear the logged-in user ID
  static Future<bool> clearLoggedInUserId() async {
    try {
      log('Clearing stored user ID');
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.remove(_userIdKey);
      
      // Clear the cache
      _cachedUserId = null;
      
      return result;
    } catch (e) {
      log('Error clearing user ID: $e');
      return false;
    }
  }
}
