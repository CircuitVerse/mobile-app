import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/utils/api_utils.dart';

import '../setup/test_data/mock_contributors.dart';

void main() {
  group('ContributorsApiTest -', () {
    group('fetchContributors -', () {
      test('When called & http client returns succes response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockContributors), 200)));
        var _contributorsApi = HttpContributorsApi();

        expect(
            (await _contributorsApi.fetchContributors()).toString(),
            circuitVerseContributorsFromJson(jsonEncode(mockContributors))
                .toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _contributorsApi = HttpContributorsApi();

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_contributorsApi.fetchContributors(),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_contributorsApi.fetchContributors(),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
