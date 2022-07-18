import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/add_group_members_response.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/group_members.dart';
import 'package:mobile_app/services/API/group_members_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_data/mock_add_group_members_response.dart';
import '../setup/test_data/mock_group_members.dart';
import '../setup/test_helpers.dart';

void main() {
  group('GroupMembersApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    var _groupMembers = GroupMembers.fromJson(mockGroupMembers);
    var _addGroupMembersResponse =
        AddGroupMembersResponse.fromJson(mockAddGroupMembersResponse);

    group('fetchGroupMembers -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGroupMembers), 200)));
        var _groupMembersApi = HttpGroupMembersApi();

        expect((await _groupMembersApi.fetchGroupMembers('1')).toString(),
            _groupMembers.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupMembersApi = HttpGroupMembersApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupMembersApi.fetchGroupMembers('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_groupMembersApi.fetchGroupMembers('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupMembersApi.fetchGroupMembers('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('addGroupMembers -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(
            Response(jsonEncode(mockAddGroupMembersResponse), 201)));
        var _groupMembersApi = HttpGroupMembersApi();

        expect(
            (await _groupMembersApi.addGroupMembers('1', '', false)).toString(),
            _addGroupMembersResponse.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupMembersApi = HttpGroupMembersApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupMembersApi.addGroupMembers('1', '', false),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_groupMembersApi.addGroupMembers('1', '', false),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupMembersApi.addGroupMembers('1', '', false),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('deleteGroupMember -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(Response('', 204)));
        var _groupMembersApi = HttpGroupMembersApi();

        expect(await _groupMembersApi.deleteGroupMember('1'), true);
      });

      test('When called & http client throws Exceptions', () async {
        var _groupMembersApi = HttpGroupMembersApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupMembersApi.deleteGroupMember('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_groupMembersApi.deleteGroupMember('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupMembersApi.deleteGroupMember('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
