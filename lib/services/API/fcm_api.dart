import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class FCMApi {
  Future<String?> sendToken(String fcmToken);
}

class HttpFCMApi implements FCMApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<String?> sendToken(String fcmToken) async {
    var endpoint = '/fcm/token';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {'token': fcmToken};

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      return jsonResponse['message'];
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on UnprocessableIdentityException {
      throw Failure(Constants.INVALID_PARAMETERS);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
