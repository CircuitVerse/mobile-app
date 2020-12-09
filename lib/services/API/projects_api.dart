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
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var projects = Projects.fromJson(jsonResponse);
      return projects;
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
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
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var projects = Projects.fromJson(jsonResponse);
      return projects;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on NotFoundException {
      throw Failure(Constants.USER_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
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
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var projects = Projects.fromJson(jsonResponse);
      return projects;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
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
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var projects = Projects.fromJson(jsonResponse);
      return projects;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Project> getProjectDetails(String id) async {
    var endpoint = '/projects/$id?include=collaborators';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var project = Project.fromJson(jsonResponse);
      return project;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
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
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
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
      var project = Project.fromJson(jsonResponse['data']);
      return project;
    } on BadRequestException {
      throw Failure(Constants.INVALID_PARAMETERS);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool> deleteProject(String projectId) async {
    var endpoint = '/projects/$projectId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

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
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<String> toggleStarProject(String projectId) async {
    var endpoint = '/projects/$projectId/toggle-star';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

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
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Project> forkProject(String toBeForkedProjectId) async {
    var endpoint = '/projects/$toBeForkedProjectId/fork';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var project = Project.fromJson(jsonResponse['data']);
      return project;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on NotFoundException {
      throw Failure(Constants.PROJECT_NOT_FOUND);
    } on ConflictException {
      throw Failure(Constants.PROJECT_FORK_CONFLICT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
