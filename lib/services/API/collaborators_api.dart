import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/add_collaborator_response.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class CollaboratorsApi {
  Future<Collaborators>? fetchProjectCollaborators(String projectId);

  Future<AddCollaboratorsResponse>? addCollaborators(
    String projectId,
    String listOfMails,
  );

  Future<bool>? deleteCollaborator(
    String projectId,
    String collaboratorId,
  );
}

class HttpCollaboratorsApi implements CollaboratorsApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<Collaborators>? fetchProjectCollaborators(String projectId) async {
    var endpoint = '/projects/$projectId/collaborators';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Collaborators.fromJson(jsonResponse);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<AddCollaboratorsResponse>? addCollaborators(
    String projectId,
    String listOfMails,
  ) async {
    var endpoint = '/projects/$projectId/collaborators';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {'emails': listOfMails};

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      var addedCollaborators = AddCollaboratorsResponse.fromJson(jsonResponse);
      return addedCollaborators;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool>? deleteCollaborator(
    String projectId,
    String collaboratorId,
  ) async {
    var endpoint = '/projects/$projectId/collaborators/$collaboratorId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      await ApiUtils.delete(
        uri,
        headers: headers,
      );
      return true;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.COLLABORATOR_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
