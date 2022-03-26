import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/models/user.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;
  static RxSharedPreferences? _rxPrefs;

  static const String USER = 'logged_in_user';
  static const String TOKEN = 'token';
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String IS_FIRST_TIME_LOGIN = 'is_first_time_login';
  static const String AUTH_TYPE = 'auth_type';
  static const String IB_SHOWCASE_STATE = 'ib_showcase_state';

  static Future<LocalStorageService> getInstance() async {
    _preferences ??= await SharedPreferences.getInstance();
    _rxPrefs ??= (_preferences)?.rx;

    return _instance ??= LocalStorageService();
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences!.get(key);
    debugPrint('LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    debugPrint('LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _rxPrefs!.setString(key, content);
    }
    if (content is bool) {
      _rxPrefs!.setBool(key, content);
    }
    if (content is int) {
      _rxPrefs!.setInt(key, content);
    }
    if (content is double) {
      _rxPrefs!.setDouble(key, content);
    }
    if (content is List<String>) {
      _rxPrefs!.setStringList(key, content);
    }
  }

  String? get token => _getFromDisk(TOKEN);

  set token(String? _token) {
    _saveToDisk(TOKEN, _token);
  }

  bool get isLoggedIn => _getFromDisk(IS_LOGGED_IN) ?? false;

  set isLoggedIn(bool isLoggedIn) {
    _saveToDisk(IS_LOGGED_IN, isLoggedIn);
  }

  bool get isFirstTimeLogin => _getFromDisk(IS_FIRST_TIME_LOGIN) ?? true;

  set isFirstTimeLogin(bool isLoggedIn) {
    _saveToDisk(IS_FIRST_TIME_LOGIN, isLoggedIn);
  }

  User? get currentUser {
    var userJson = _getFromDisk(USER);
    if (userJson == null || userJson == 'null') {
      return null;
    }

    return User.fromJson(json.decode(userJson));
  }

  set currentUser(User? userToSave) {
    _saveToDisk(USER, json.encode(userToSave?.toJson()));
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
                as Map<dynamic, dynamic>);
    return result;
  }

  set setShowcaseState(String state) {
    _saveToDisk(IB_SHOWCASE_STATE, state);
  }

  Stream<User?> userStream() {
    return _rxPrefs!.observe<String>(
      USER,
      (userJson) {
        return userJson as String?;
      },
    ).map<User?>((user) {
      if (user == null || user == 'null') {
        return null;
      }

      return User.fromJson(json.decode(user));
    });
  }
}
