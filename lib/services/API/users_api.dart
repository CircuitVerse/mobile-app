import 'package:http/http.dart' as http;
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class UsersApi {
  Future<String> login(String email, String password);

  Future<String> signup(String name, String email, String password);

  Future<String> oauth_login({String accessToken, String provider});

  Future<String> oauth_signup({String accessToken, String provider});

  Future<User> fetchUser(String userId);

  Future<User> fetchCurrentUser();

  Future<User> updateProfile(String name, String educationalInstitute,
      String country, bool subscribed);

  Future<bool> sendResetPasswordInstructions(String email);
}

class HttpUsersApi implements UsersApi {
  var headers = {'Content-Type': 'application/json'};
  http.Client client = http.Client();

  final LocalStorageService _storage = locator<LocalStorageService>();

  @override
  Future<String> login(String email, String password) async {
    var endpoint = '/auth/login';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'email': email,
      'password': password,
    };
    try {
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      String token = jsonResponse['token'];
      return token;
    } on UnauthorizedException {
      throw Failure(Constants.USER_AUTH_WRONG_CREDENTIALS);
    } on NotFoundException {
      throw Failure(Constants.USER_AUTH_USER_NOT_FOUND);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<String> signup(String name, String email, String password) async {
    var endpoint = '/auth/signup';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'name': name,
      'email': email,
      'password': password,
    };
    try {
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      String token = jsonResponse['token'];
      return token;
    } on ConflictException {
      throw Failure(Constants.USER_AUTH_USER_ALREADY_EXISTS);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<String> oauth_login({String accessToken, String provider}) async {
    var endpoint = '/oauth/login';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'access_token': accessToken,
      'provider': provider,
    };

    try {
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      String token = jsonResponse['token'];
      return token;
    } on NotFoundException {
      throw Failure(Constants.USER_AUTH_USER_NOT_FOUND);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<String> oauth_signup({String accessToken, String provider}) async {
    var endpoint = '/oauth/signup';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'access_token': accessToken,
      'provider': provider,
    };

    try {
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      String token = jsonResponse['token'];
      return token;
    } on ConflictException {
      throw Failure(Constants.USER_AUTH_USER_ALREADY_EXISTS);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<User> fetchUser(String userId) async {
    var endpoint = '/users/$userId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var user = User.fromJson(jsonResponse);
      return user;
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on NotFoundException {
      throw Failure(Constants.USER_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<User> fetchCurrentUser() async {
    var endpoint = '/me/';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var user = User.fromJson(jsonResponse);
      return user;
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<User> updateProfile(String name, String educationalInstitute,
      String country, bool isSubscribed) async {
    var endpoint = '/users/${_storage.currentUser.data.id}';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'name': name,
      'educational_institute': educationalInstitute,
      'country': country,
      'subscribed': isSubscribed,
    };
    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(
        uri,
        headers: headers,
        body: json,
      );
      var user = User.fromJson(jsonResponse);
      return user;
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool> sendResetPasswordInstructions(String email) async {
    var endpoint = '/password/forgot';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {'email': email};
    try {
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      return jsonResponse['message'] is String;
    } on NotFoundException {
      throw Failure(Constants.USER_NOT_FOUND);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
