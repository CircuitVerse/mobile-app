import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class ProjectsApi {
  Future<Projects> getPublicProjects({
    int page = 1,
    String filterByTag,
    String sortBy,
  });

  Future<Projects> getUserProjects(
    String userId, {
    int page = 1,
    String filterByTag,
    String sortBy,
  });

  Future<Projects> getFeaturedProjects({
    int page = 1,
    int size = 5,
    String filterByTag,
    String sortBy,
  });

  Future<Projects> getUserFavourites(
    String userId, {
    int page = 1,
    String filterByTag,
    String sortBy,
  });

  Future<Project> getProjectDetails(String id);

  Future<Project> updateProject(
    String id, {
    String name,
    String projectAccessType,
    String description,
    List<String> tagsList,
  });

  Future<bool> deleteProject(String projectId);

  Future<String> toggleStarProject(String projectId);

  Future<Project> forkProject(String toBeForkedProjectId);
}

class HttpProjectsApi implements ProjectsApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<Projects> getPublicProjects({
    int page = 1,
    String filterByTag,
    String sortBy,
  }) async {
    var endpoint = '/projects?page[number]=$page';
    if (filterByTag != null) endpoint += '&filter[tag]=$filterByTag';
    if (sortBy != null) endpoint += '&sort=$sortBy';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Projects.fromJson(jsonResponse);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<Projects> getUserProjects(
    String userId, {
    int page = 1,
    String filterByTag,
    String sortBy,
  }) async {
    var endpoint = '/users/$userId/projects?page[number]=$page';
    if (filterByTag != null) endpoint += '&filter[tag]=$filterByTag';
    if (sortBy != null) endpoint += '&sort=$sortBy';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Projects.fromJson(jsonResponse);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on NotFoundException {
      throw Failure(Constants.userNOTFOUND);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<Projects> getFeaturedProjects({
    int page = 1,
    int size = 5,
    String filterByTag,
    String sortBy,
  }) async {
    var endpoint = '/projects/featured?page[number]=$page&page[size]=$size';
    if (filterByTag != null) endpoint += '&filter[tag]=$filterByTag';
    if (sortBy != null) endpoint += '&sort=$sortBy';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Projects.fromJson(jsonResponse);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<Projects> getUserFavourites(
    String userId, {
    int page = 1,
    String filterByTag,
    String sortBy,
  }) async {
    var endpoint = '/users/$userId/favourites?page[number]=$page';
    if (filterByTag != null) endpoint += '&filter[tag]=$filterByTag';
    if (sortBy != null) endpoint += '&sort=$sortBy';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Projects.fromJson(jsonResponse);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<Project> getProjectDetails(String id) async {
    var endpoint = '/projects/$id?include=collaborators';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Project.fromJson(jsonResponse);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.projectNOTFOUND);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<Project> updateProject(
    String id, {
    String name,
    String projectAccessType,
    String description,
    List<String> tagsList,
  }) async {
    var endpoint = '/projects/$id';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;
    var json = {
      'name': name,
      'project_access_type': projectAccessType,
      'description': description,
      'tags_list': tagsList.join(','),
    };

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(
        uri,
        headers: headers,
        body: json,
      );
      return Project.fromJson(jsonResponse['data']);
    } on BadRequestException {
      throw Failure(Constants.invalidPARAMETERS);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.projectNOTFOUND);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<bool> deleteProject(String projectId) async {
    var endpoint = '/projects/$projectId';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      await ApiUtils.delete(
        uri,
        headers: headers,
      );
      return true;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.projectNOTFOUND);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<String> toggleStarProject(String projectId) async {
    var endpoint = '/projects/$projectId/toggle-star';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return jsonResponse['message'];
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on NotFoundException {
      throw Failure(Constants.projectNOTFOUND);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<Project> forkProject(String toBeForkedProjectId) async {
    var endpoint = '/projects/$toBeForkedProjectId/fork';
    var uri = EnvironmentConfig.cvAPIBASEURL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return Project.fromJson(jsonResponse['data']);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on NotFoundException {
      throw Failure(Constants.projectNOTFOUND);
    } on ConflictException {
      throw Failure(Constants.projectFORKCONFLICT);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    }
  }
}
