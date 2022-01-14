import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class AssignmentsApi {
  Future<Assignments>? fetchAssignments(String groupId, {int page = 1});

  Future<Assignment>? fetchAssignmentDetails(String assignmentId);

  Future<Assignment>? addAssignment(
    String groupId,
    String name,
    String deadline,
    String description,
    String gradingScale,
    String resctrictions,
  );

  Future<Assignment>? updateAssignment(
    String assignmentId,
    String name,
    String deadline,
    String description,
    String restrictions,
  );

  Future<bool>? deleteAssignment(String assignmentId);

  Future<String>? reopenAssignment(String assignmentId);

  Future<String>? startAssignment(String assignmentId);
}

class HttpAssignmentsApi implements AssignmentsApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<Assignments>? fetchAssignments(String groupId, {int page = 1}) async {
    var endpoint = '/groups/$groupId/assignments?page[number]=$page';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Assignments.fromJson(jsonResponse);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Assignment>? fetchAssignmentDetails(String assignmentId) async {
    var endpoint = '/assignments/$assignmentId?include=grades,projects';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var assignment = Assignment.fromJson(jsonResponse);
      return assignment;
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Assignment>? addAssignment(
    String groupId,
    String name,
    String deadline,
    String description,
    String gradingScale,
    String restrictions,
  ) async {
    var endpoint = '/groups/$groupId/assignments';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'name': name,
      'deadline': deadline,
      'description': description,
      'grading_scale': gradingScale,
      'restrictions': restrictions
    };

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      return Assignment.fromJson(jsonResponse['data']);
    } on BadRequestException {
      throw Failure(Constants.INVALID_PARAMETERS);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Assignment>? updateAssignment(
    String assignmentId,
    String name,
    String deadline,
    String description,
    String restrictions,
  ) async {
    var endpoint = '/assignments/$assignmentId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'name': name,
      'deadline': deadline,
      'description': description,
      'restrictions': restrictions,
    };

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(
        uri,
        headers: headers,
        body: json,
      );
      var assignment = Assignment.fromJson(jsonResponse['data']);
      return assignment;
    } on BadRequestException {
      throw Failure(Constants.INVALID_PARAMETERS);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool>? deleteAssignment(String assignmentId) async {
    var endpoint = '/assignments/$assignmentId';
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
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<String>? reopenAssignment(String assignmentId) async {
    var endpoint = '/assignments/$assignmentId/reopen';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(uri, headers: headers, body: {});
      return jsonResponse['message'];
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on ConflictException {
      throw Failure(Constants.ASSIGNMENT_ALREADY_OPENED);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<String>? startAssignment(String assignmentId) async {
    var endpoint = '/assignments/$assignmentId/start';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(uri, headers: headers, body: {});
      return jsonResponse['message'];
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.ASSIGNMENT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
