import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/API/ib_api.dart';
import 'package:mobile_app/utils/api_utils.dart';

import '../setup/test_data/mock_ib_raw_page.dart';
import '../setup/test_data/mock_ib_raw_page_data.dart';

void main() {
  group('IbApiTest -', () {
    group('fetchApiPage -', () {
      test('When called & http client returns succes response', () async {
        ApiUtils.client = MockClient((_) => Future.value(
            Response(jsonEncode([mockIbRawPageData1, mockIbRawPage2]), 200)));
        var _ibApi = HttpIbApi();

        expect((await _ibApi.fetchApiPage()).toString(),
            [mockIbRawPageData1, mockIbRawPage2].toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _ibApi = HttpIbApi();

        ApiUtils.client = MockClient((_) => throw FormatException(''));
        expect(_ibApi.fetchApiPage(), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_ibApi.fetchApiPage(), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('fetchRawPageData -', () {
      test('When called & http client returns succes response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockIbRawPageData1), 200)));
        var _ibApi = HttpIbApi();

        expect((await _ibApi.fetchRawPageData()).toString(),
            IbRawPageData.fromJson(mockIbRawPageData1).toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _ibApi = HttpIbApi();

        ApiUtils.client = MockClient((_) => throw FormatException(''));
        expect(_ibApi.fetchRawPageData(), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_ibApi.fetchRawPageData(), throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
