import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/models/user.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  static FlutterSecureStorage? _secureStorage;

  SecureStorageService._();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  static const IOSOptions _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
  );

  static Future<SecureStorageService> getInstance() async {
    _secureStorage ??= const FlutterSecureStorage(
      iOptions: _iosOptions,
    );
    return _instance ??= SecureStorageService._();
  }

  Future<String?> get token async {
    try {
      return await _secureStorage!.read(key: _tokenKey);
    } catch (_) {
      await _secureStorage!.delete(key: _tokenKey);
      return null;
    }
  }

  Future<void> setToken(String? token) async {
    if (token == null) {
      await _secureStorage!.delete(key: _tokenKey);
    } else {
      await _secureStorage!.write(key: _tokenKey, value: token);
    }
  }

  Future<User?> get currentUser async {
    try {
      final userJson = await _secureStorage!.read(key: _userKey);
      if (userJson == null || userJson == 'null') {
        return null;
      }
      return User.fromJson(json.decode(userJson));
    } catch (_) {
      await _secureStorage!.delete(key: _userKey);
      return null;
    }
  }

  Future<void> setCurrentUser(User? user) async {
    if (user == null) {
      await _secureStorage!.delete(key: _userKey);
    } else {
      await _secureStorage!.write(key: _userKey, value: json.encode(user.toJson()));
    }
  }

  Future<void> deleteAll() async {
    await _secureStorage!.delete(key: _tokenKey);
    await _secureStorage!.delete(key: _userKey);
  }
}
