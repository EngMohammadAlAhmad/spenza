
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spenza/core/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static String? _cachedAuthToken;

  //! Here The Initialize of cache .
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _migrateLegacyAuthToken();
    await _loadAuthToken();
  }

  //! Persists the JWT in encrypted secure storage (not plain SharedPreferences).
  Future<bool> saveAuthToken(String token) async {
    _cachedAuthToken = token;
    await _secureStorage.write(key: Strings.TOKEN_KEY, value: token);
    return true;
  }

  //! Returns the in-memory JWT loaded from secure storage during init or login.
  String getAuthToken() => _cachedAuthToken ?? '';

  //! Removes the JWT from secure storage and memory.
  Future<bool> deleteAuthToken() async {
    _cachedAuthToken = null;
    await _secureStorage.delete(key: Strings.TOKEN_KEY);
    await sharedPreferences.remove(Strings.TOKEN_KEY);
    return true;
  }

  Future<void> _loadAuthToken() async {
    _cachedAuthToken = await _secureStorage.read(key: Strings.TOKEN_KEY);
  }

  Future<void> _migrateLegacyAuthToken() async {
    final legacyToken = sharedPreferences.getString(Strings.TOKEN_KEY);
    if (legacyToken == null || legacyToken.isEmpty) return;

    await _secureStorage.write(key: Strings.TOKEN_KEY, value: legacyToken);
    await sharedPreferences.remove(Strings.TOKEN_KEY);
  }

//! this method to put data in local database using key

  String? getDataString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

//! this method to put data in local database using key

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    }
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    }

    if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

//! this method to get data already saved in local database

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

//! remove data using specific key

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

//! this method to check if local database contains {key}
  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

//! clear all data in the local database
  Future<bool> clearData() async {
    _cachedAuthToken = null;
    await _secureStorage.delete(key: Strings.TOKEN_KEY);
    return await sharedPreferences.clear();
  }

//! this method to put data in local database using key
  Future<dynamic> put({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else {
      return await sharedPreferences.setInt(key, value);
    }
  }
}
