import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/grade.dart';
import 'package:mobile_app/services/API/grades_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_data/mock_grade.dart';
import '../setup/test_helpers.dart';

void main() {
  group('GradesApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    var _grade = Grade.fromJson(mockGrade['data']);

    group('addGrade -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGrade), 201)));
        var _gradesApi = HttpGradesApi();

        expect((await _gradesApi.addGrade('1', '1', 'A', 'Good')).toString(),
            _grade.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _gradesApi = HttpGradesApi();

        ApiUtils.client = MockClient(((_) => throw ForbiddenException('')));
        expect(_gradesApi.addGrade('1', '1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw NotFoundException('')));
        expect(_gradesApi.addGrade('1', '1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client =
            MockClient(((_) => throw UnprocessableIdentityException('')));
        expect(_gradesApi.addGrade('1', '1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw Exception('')));
        expect(_gradesApi.addGrade('1', '1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('updateGrade -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockGrade), 202)));
        var _gradesApi = HttpGradesApi();

        expect((await _gradesApi.updateGrade('1', 'A', 'Good')).toString(),
            _grade.toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _gradesApi = HttpGradesApi();

        ApiUtils.client = MockClient(((_) => throw ForbiddenException('')));
        expect(_gradesApi.updateGrade('1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw NotFoundException('')));
        expect(_gradesApi.updateGrade('1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client =
            MockClient(((_) => throw UnprocessableIdentityException('')));
        expect(_gradesApi.updateGrade('1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw Exception('')));
        expect(_gradesApi.updateGrade('1', 'A', 'Good'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('deleteGrade -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient((_) => Future.value(Response('', 204)));
        var _gradesApi = HttpGradesApi();

        expect(await _gradesApi.deleteGrade('1'), true);
      });

      test('When called & http client throws Exceptions', () async {
        var _gradesApi = HttpGradesApi();

        ApiUtils.client = MockClient(((_) => throw ForbiddenException('')));
        expect(_gradesApi.deleteGrade('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw NotFoundException('')));
        expect(_gradesApi.deleteGrade('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient(((_) => throw Exception('')));
        expect(_gradesApi.deleteGrade('1'), throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
