import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_data/mock_groups.dart';
import '../setup/test_helpers.dart';

void main() {
  group('GroupsApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    var _groups = Groups.fromJson(mockGroups);
    var _group = Group.fromJson(mockGroup);

    group('fetchMemberGroups -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGroups), 200)));
        var _groupsApi = HttpGroupsApi();

        expect((await _groupsApi.fetchMemberGroups()).toString(),
            _groups.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupsApi = HttpGroupsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(
            _groupsApi.fetchMemberGroups(), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _groupsApi.fetchMemberGroups(), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('fetchMentoringGroups -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGroups), 200)));
        var _groupsApi = HttpGroupsApi();

        expect((await _groupsApi.fetchOwnedGroups()).toString(),
            _groups.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupsApi = HttpGroupsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupsApi.fetchOwnedGroups(), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupsApi.fetchOwnedGroups(), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('fetchGroupDetails -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGroup), 200)));
        var _groupsApi = HttpGroupsApi();

        expect((await _groupsApi.fetchGroupDetails('1')).toString(),
            _group.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupsApi = HttpGroupsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupsApi.fetchGroupDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_groupsApi.fetchGroupDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_groupsApi.fetchGroupDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupsApi.fetchGroupDetails('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('addGroup -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGroup), 201)));
        var _groupsApi = HttpGroupsApi();

        expect((await _groupsApi.addGroup('Test Group')).toString(),
            _group.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupsApi = HttpGroupsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupsApi.addGroup('Test Group'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupsApi.addGroup('Test Group'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('updateGroup -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGroup), 202)));
        var _groupsApi = HttpGroupsApi();

        expect((await _groupsApi.updateGroup('1', 'Test Group')).toString(),
            _group.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _groupsApi = HttpGroupsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupsApi.updateGroup('1', 'Test Group'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_groupsApi.updateGroup('1', 'Test Group'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_groupsApi.updateGroup('1', 'Test Group'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupsApi.updateGroup('1', 'Test Group'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('deleteGroup -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(Response('', 204)));
        var _groupsApi = HttpGroupsApi();

        expect(await _groupsApi.deleteGroup('1'), true);
      });

      test('When called & http client throws Exceptions', () async {
        var _groupsApi = HttpGroupsApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_groupsApi.deleteGroup('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_groupsApi.deleteGroup('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_groupsApi.deleteGroup('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_groupsApi.deleteGroup('1'), throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
