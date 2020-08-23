import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class GroupsApi {
  Future<Groups> fetchMemberGroups({int page = 1});

  Future<Groups> fetchMentoringGroups({int page = 1});

  Future<Group> fetchGroupDetails(String groupId);

  Future<Group> addGroup(String name);

  Future<Group> updateGroup(String groupId, String name);

  Future<bool> deleteGroup(String groupId);
}

class HttpGroupsApi implements GroupsApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<Groups> fetchMemberGroups({int page = 1}) async {
    var endpoint = '/groups?page[number]=$page';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var groups = Groups.fromJson(jsonResponse);
      return groups;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Groups> fetchMentoringGroups({int page = 1}) async {
    var endpoint = '/groups/mentored?page[number]=$page';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var groups = Groups.fromJson(jsonResponse);
      return groups;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Group> fetchGroupDetails(String groupId) async {
    var endpoint = '/groups/$groupId?include=group_members,assignments';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      var group = Group.fromJson(jsonResponse);
      return group;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Group> addGroup(String name) async {
    var endpoint = '/groups';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {'name': name};

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      var group = Group.fromJson(jsonResponse);
      return group;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<Group> updateGroup(String groupId, String name) async {
    var endpoint = '/groups/$groupId?include=group_members,assignments';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {'name': name};

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.patch(
        uri,
        headers: headers,
        body: json,
      );
      var group = Group.fromJson(jsonResponse);
      return group;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHENTICATED);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool> deleteGroup(String groupId) async {
    var endpoint = '/groups/$groupId';
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
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
