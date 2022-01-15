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

  Future<String> oauthLogin({String accessToken, String provider});

  Future<String> oauthSignup({String accessToken, String provider});

  Future<User> fetchUser(String userId);

  Future<User> fetchCurrentUser();

  Future<User> updateProfile(String name, String educationalInstitute,
      String country, bool subscribed);

  Future<bool> sendResetPasswordInstructions(String email);
}

class HttpUsersApi implements UsersApi {
  var headers = {'Content-Type': 'application/json'};

  final LocalStorageService _storage = locator<LocalStorageService>();

  @override
  Future<String> login(String email, String password) async {
    var endpoint = '/auth/login';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
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
      throw Failure(Constants.userAUTHWRONGCREDENTIALS);
    } on NotFoundException {
      throw Failure(Constants.userAUTHUSERNOTFOUND);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<String> signup(String name, String email, String password) async {
    var endpoint = '/auth/signup';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
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
      return jsonResponse['token'];
    } on ConflictException {
      throw Failure(Constants.userAUTHUSERALREADYEXISTS);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<String> oauthLogin({String accessToken, String provider}) async {
    var endpoint = '/oauth/login';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
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
      return jsonResponse['token'];
    } on NotFoundException {
      throw Failure(Constants.userAUTHUSERNOTFOUND);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<String> oauthSignup({String accessToken, String provider}) async {
    var endpoint = '/oauth/signup';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
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
      return jsonResponse['token'];
    } on ConflictException {
      throw Failure(Constants.userAUTHUSERALREADYEXISTS);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<User> fetchUser(String userId) async {
    var endpoint = '/users/$userId';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return User.fromJson(jsonResponse);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on NotFoundException {
      throw Failure(Constants.userNOTFOUND);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<User> fetchCurrentUser() async {
    var endpoint = '/me/';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return User.fromJson(jsonResponse);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<User> updateProfile(String name, String educationalInstitute,
      String country, bool isSubscribed) async {
    var endpoint = '/users/${_storage.currentUser.data.id}';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
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
      return User.fromJson(jsonResponse);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<bool> sendResetPasswordInstructions(String email) async {
    var endpoint = '/password/forgot';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
    var json = {'email': email};
    try {
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      return jsonResponse['message'] is String;
    } on NotFoundException {
      throw Failure(Constants.userNOTFOUND);
    } on FormatException {
      throw Failure(Constants.badRESPONSEFORMAT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }
}
