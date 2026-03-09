import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/secure_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;
  static SecureStorageService? _secureStorage;

  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String IS_FIRST_TIME_LOGIN = 'is_first_time_login';
  static const String AUTH_TYPE = 'auth_type';
  static const String IB_SHOWCASE_STATE = 'ib_showcase_state';

  static Future<LocalStorageService> getInstance() async {
    _preferences ??= await SharedPreferences.getInstance();
    _secureStorage ??= await SecureStorageService.getInstance();

    return _instance ??= LocalStorageService();
  }

  dynamic _getFromDisk(String key) {
    return _preferences!.get(key);
  }

  void _saveToDisk<T>(String key, T content) {
    if (content is String) {
      _preferences!.setString(key, content);
    }
    if (content is bool) {
      _preferences!.setBool(key, content);
    }
    if (content is int) {
      _preferences!.setInt(key, content);
    }
    if (content is double) {
      _preferences!.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences!.setStringList(key, content);
    }
  }

  bool _initialized = false;
  String? _cachedToken;
  User? _cachedUser;

  Future<String?> getToken() async {
    _cachedToken ??= await _secureStorage!.token;
    return _cachedToken;
  }

  String? get token {
    assert(_initialized, 'LocalStorageService.token accessed before initializeSecureData() was called.');
    return _cachedToken;
  }

  set token(String? _token) {
    _cachedToken = _token;
    _secureStorage!.setToken(_token).catchError((e) {
      debugPrint('Failed to persist token to secure storage: $e');
    });
  }

  bool get isLoggedIn => _getFromDisk(IS_LOGGED_IN) ?? false;

  set isLoggedIn(bool isLoggedIn) {
    _saveToDisk(IS_LOGGED_IN, isLoggedIn);
  }

  bool get isFirstTimeLogin => _getFromDisk(IS_FIRST_TIME_LOGIN) ?? true;

  set isFirstTimeLogin(bool isLoggedIn) {
    _saveToDisk(IS_FIRST_TIME_LOGIN, isLoggedIn);
  }

  Future<User?> getCurrentUser() async {
    _cachedUser ??= await _secureStorage!.currentUser;
    return _cachedUser;
  }

  User? get currentUser {
    assert(_initialized, 'LocalStorageService.currentUser accessed before initializeSecureData() was called.');
    return _cachedUser;
  }

  set currentUser(User? userToSave) {
    _cachedUser = userToSave;
    _secureStorage!.setCurrentUser(userToSave).catchError((e) {
      debugPrint('Failed to persist currentUser to secure storage: $e');
    });
  }

  AuthType? get authType {
    var _authType = _getFromDisk(AUTH_TYPE);
    return authTypeValues.map[_authType];
  }

  set authType(AuthType? authType) {
    _saveToDisk(AUTH_TYPE, authTypeValues.reverse[authType]);
  }

  Map<String, dynamic> get getShowcaseState {
    final Map<String, dynamic> result =
        Map.castFrom<dynamic, dynamic, String, dynamic>(
          json.decode(_getFromDisk(IB_SHOWCASE_STATE) ?? '{}')
              as Map<dynamic, dynamic>,
        );
    return result;
  }

  set setShowcaseState(String state) {
    _saveToDisk(IB_SHOWCASE_STATE, state);
  }

  Future<void> initializeSecureData() async {
    _cachedToken = await _secureStorage!.token;
    _cachedUser = await _secureStorage!.currentUser;
    final hasToken = _cachedToken?.isNotEmpty == true;
    final hasUser = _cachedUser != null;
    if (hasToken != hasUser) {
      await _secureStorage!.deleteAll();
      _cachedToken = null;
      _cachedUser = null;
      isLoggedIn = false;
    }
    _initialized = true;
  }

  Future<void> clearSecureData() async {
    _cachedToken = null;
    _cachedUser = null;
    await _secureStorage!.deleteAll();
  }
}
