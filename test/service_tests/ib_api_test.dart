import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/API/ib_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../setup/test_data/mock_ib_raw_page.dart';
import '../setup/test_data/mock_ib_raw_page_data.dart';

void main() {
  group('IbApiTest -', () {
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    group('fetchApiPage -', () {
      setUpAll(() async {
        var path = Directory.current.path;
        Hive.init('$path/test/hive_testing_path');
      });

      test('When called & http client returns succes response', () async {
        await Hive.deleteFromDisk();

        ApiUtils.client = MockClient((_) => Future.value(
            Response(jsonEncode([mockIbRawPage1, mockIbRawPage2]), 200)));
        var _ibApi = HttpIbApi();

        expect((await _ibApi.fetchApiPage()).toString(),
            [mockIbRawPage1, mockIbRawPage2].toString());
      });

      test('When called & http client throws Exceptions', () async {
        await Hive.deleteFromDisk();

        var _ibApi = HttpIbApi();

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
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

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_ibApi.fetchRawPageData(), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_ibApi.fetchRawPageData(), throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
