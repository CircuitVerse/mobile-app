import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/services/API/country_institute_api.dart';

import '../setup/test_data/mock_country_data.dart';
import '../setup/test_data/mock_institutes_data.dart';

void main() {
  group('CountryApi -', () {
    group('fetchCountries -', () {
      test('When called & http client returns succes response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockCountries), 200)));
        var _countryApi = HttpCountryInstituteAPI();

        expect(
          (await _countryApi.getCountries(
            'ta',
          ))
              .toString(),
          [].toString(),
        );

        expect(
          (await _countryApi.getCountries(
            't',
          ))
              .toString(),
          ['Test'].toString(),
        );

        expect(
          (await _countryApi.getCountries(
            '',
          ))
              .toString(),
          ['Test'].toString(),
        );
      });

      test('When called & http client throws Exceptions', () async {
        var _countriesApi = HttpCountryInstituteAPI();

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _countriesApi.getCountries(
              '',
            ),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });

  group('InstituteApi -', () {
    group('fetchInstitutes -', () {
      test('When called & http client returns succes response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response(jsonEncode(mockInstitutes), 200)));
        var _countryApi = HttpCountryInstituteAPI();

        expect(
          (await _countryApi.getInstitutes(
            'ta',
          ))
              .toString(),
          [].toString(),
        );

        expect(
          (await _countryApi.getInstitutes(
            't',
          ))
              .toString(),
          ['Test'].toString(),
        );

        expect(
          (await _countryApi.getInstitutes(
            '',
          ))
              .toString(),
          ['Test'].toString(),
        );
      });

      test('When called & http client throws Exceptions', () async {
        var _countriesApi = HttpCountryInstituteAPI();

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _countriesApi.getInstitutes(
              '',
            ),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
