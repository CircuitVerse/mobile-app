import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/grade.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class GradesApi {
  Future<Grade>? addGrade(
    String assignmentId,
    String projectId,
    dynamic grade,
    String remarks,
  );

  Future<Grade>? updateGrade(
    String gradeId,
    dynamic grade,
    String remarks,
  );

  Future<bool>? deleteGrade(String gradeId);
}

class HttpGradesApi implements GradesApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<Grade>? addGrade(
    String assignmentId,
    String projectId,
    dynamic grade,
    String remarks,
  ) async {
    var endpoint = '/assignments/$assignmentId/projects/$projectId/grades';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'grade': {
        'grade': grade,
        'remarks': remarks,
      }
    };

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      return Grade.fromJson(jsonResponse['data']);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on UnprocessableIdentityException {
      throw Failure(Constants.INVALID_PARAMETERS);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Grade>? updateGrade(
    String gradeId,
    dynamic grade,
    String remarks,
  ) async {
    var endpoint = '/grades/$gradeId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'grade': {
        'grade': grade,
        'remarks': remarks,
      }
    };

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(
        uri,
        headers: headers,
        body: json,
      );
      var grade = Grade.fromJson(jsonResponse['data']);
      return grade;
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on UnprocessableIdentityException {
      throw Failure(Constants.INVALID_PARAMETERS);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool>? deleteGrade(String gradeId) async {
    var endpoint = '/grades/$gradeId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      await ApiUtils.delete(
        uri,
        headers: headers,
      );
      return true;
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GRADE_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
