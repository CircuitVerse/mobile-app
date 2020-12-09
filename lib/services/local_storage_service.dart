import 'dart:convert';

import 'package:mobile_app/enums/auth_type.dart';
import 'package:mobile_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static const String USER = 'logged_in_user';
  static const String TOKEN = 'token';
  static const String IS_LOGGED_IN = 'is_logged_in';
  static const String IS_FIRST_TIME_LOGIN = 'is_first_time_login';
  static const String AUTH_TYPE = 'auth_type';

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();

    _preferences ??= await SharedPreferences.getInstance();

    return _instance;
  }

  dynamic _getFromDisk(String key) {
    var value = _preferences.get(key);
    print('LocalStorageService:_getFromDisk. key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    print('LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }

  String get token => _getFromDisk(TOKEN);

  set token(String _token) {
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

  User get currentUser {
    var userJson = _getFromDisk(USER);
    if (userJson == null || userJson == 'null') {
      return null;
    }

    return User.fromJson(json.decode(userJson));
  }

  set currentUser(User userToSave) {
    _saveToDisk(USER, json.encode(userToSave?.toJson()));
  }

  AuthType get authType {
    var _authType = _getFromDisk(AUTH_TYPE);
    return authTypeValues.map[_authType];
  }

  set authType(AuthType authType) {
    _saveToDisk(AUTH_TYPE, authTypeValues.reverse[authType]);
  }
}
