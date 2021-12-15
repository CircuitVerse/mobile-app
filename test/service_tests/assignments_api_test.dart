import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_data/mock_assignments.dart';
import '../setup/test_helpers.dart';

void main() {
  group('AssignmentsApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    var _assignments = Assignments.fromJson(mockAssignments);
    var _assignment = Assignment.fromJson(mockAssignment);

    group('fetchAssignments -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockAssignments), 200)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect((await _assignmentsApi.fetchAssignments('1')).toString(),
            _assignments.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_assignmentsApi.fetchAssignments('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_assignmentsApi.fetchAssignments('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_assignmentsApi.fetchAssignments('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('fetchAssignmentDetails -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockAssignment), 200)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect((await _assignmentsApi.fetchAssignmentDetails('1')).toString(),
            _assignment.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_assignmentsApi.fetchAssignmentDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_assignmentsApi.fetchAssignmentDetails('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_assignmentsApi.fetchAssignmentDetails('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('addAssignment -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockAssignment), 201)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect(
            (await _assignmentsApi.addAssignment(
                    '1', 'Test', 'deadline', 'description', 'letter', '[]'))
                .toString(),
            _assignment.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw BadRequestException(''));
        expect(
            _assignmentsApi.addAssignment(
                '1', 'Test', 'deadline', 'description', 'letter', '[]'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
            _assignmentsApi.addAssignment(
                '1', 'Test', 'deadline', 'description', 'letter', '[]'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
            _assignmentsApi.addAssignment(
                '1', 'Test', 'deadline', 'description', 'letter', '[]'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _assignmentsApi.addAssignment(
                '1', 'Test', 'deadline', 'description', 'letter', '[]'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('updateAssignment -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockAssignment), 202)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect(
            (await _assignmentsApi.updateAssignment(
                    '1', 'Test', 'deadline', 'description', '[]'))
                .toString(),
            _assignment.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw BadRequestException(''));
        expect(
            _assignmentsApi.updateAssignment(
                '1', 'Test', 'deadline', 'description', '[]'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
            _assignmentsApi.updateAssignment(
                '1', 'Test', 'deadline', 'description', '[]'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
            _assignmentsApi.updateAssignment(
                '1', 'Test', 'deadline', 'description', '[]'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _assignmentsApi.updateAssignment(
                '1', 'Test', 'deadline', 'description', '[]'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('deleteAssignment -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(Response('', 204)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect(await _assignmentsApi.deleteAssignment('1'), true);
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_assignmentsApi.deleteAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_assignmentsApi.deleteAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_assignmentsApi.deleteAssignment('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('reopenAssignment -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"message": "reopened"}', 200)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect(await _assignmentsApi.reopenAssignment('1'), 'reopened');
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_assignmentsApi.reopenAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_assignmentsApi.reopenAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw ConflictException(''));
        expect(_assignmentsApi.reopenAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_assignmentsApi.reopenAssignment('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('startAssignment -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) =>
            Future.value(Response('{"message": "project created"}', 200)));
        var _assignmentsApi = HttpAssignmentsApi();

        expect(await _assignmentsApi.startAssignment('1'), 'project created');
      });

      test('When called & http client throws Exceptions', () async {
        var _assignmentsApi = HttpAssignmentsApi();

        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(_assignmentsApi.startAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_assignmentsApi.startAssignment('1'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_assignmentsApi.startAssignment('1'),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
