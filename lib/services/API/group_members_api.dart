import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/add_group_members_response.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class GroupMembersApi {
  Future<GroupMembers>? fetchGroupMembers(String groupId);

  Future<AddGroupMembersResponse>? addGroupMembers(
      String groupId, String listOfMails, bool isMentor);

  Future updateMemberRole(String memberId, bool isMentor);

  Future<bool>? deleteGroupMember(String groupMemberId);
}

class HttpGroupMembersApi implements GroupMembersApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<GroupMembers>? fetchGroupMembers(String groupId) async {
    var endpoint = '/groups/$groupId/members';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.get(
        uri,
        headers: headers,
      );
      return GroupMembers.fromJson(jsonResponse);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<AddGroupMembersResponse>? addGroupMembers(
      String groupId, String listOfMails, bool isMentor) async {
    var endpoint = '/groups/$groupId/members';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {'emails': listOfMails, 'mentor': isMentor};

    try {
      ApiUtils.addTokenToHeaders(headers);
      var jsonResponse = await ApiUtils.post(
        uri,
        headers: headers,
        body: json,
      );
      var addGroupMembers = AddGroupMembersResponse.fromJson(jsonResponse);
      return addGroupMembers;
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future updateMemberRole(String memberId, bool isMentor) async {
    var endpoint = '/group/members/$memberId';
    var uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;
    var json = {
      'group_member': {'mentor': isMentor}
    };

    try {
      ApiUtils.addTokenToHeaders(headers);
      await ApiUtils.patch(uri, headers: headers, body: json);
    } on UnauthorizedException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_MEMBER_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<bool>? deleteGroupMember(String groupMemberId) async {
    var endpoint = '/group/members/$groupMemberId';
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
      throw Failure(Constants.GROUP_MEMBER_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
