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
          (await _countryApi.getSuggestions('ta', CountryInstituteAPI.COUNTRY))
              .toString(),
          [].toString(),
        );

        expect(
          (await _countryApi.getSuggestions('t', CountryInstituteAPI.COUNTRY))
              .toString(),
          ['Test'].toString(),
        );

        expect(
          (await _countryApi.getSuggestions('', CountryInstituteAPI.COUNTRY))
              .toString(),
          ['Test'].toString(),
        );
      });

      test('When called & http client throws Exceptions', () async {
        var _countriesApi = HttpCountryInstituteAPI();

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_countriesApi.getSuggestions('', ''),
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
          (await _countryApi.getSuggestions(
                  'ta', CountryInstituteAPI.EDUCATIONAL_INSTITUTE))
              .toString(),
          [].toString(),
        );

        expect(
          (await _countryApi.getSuggestions(
                  't', CountryInstituteAPI.EDUCATIONAL_INSTITUTE))
              .toString(),
          ['Test'].toString(),
        );

        expect(
          (await _countryApi.getSuggestions(
                  '', CountryInstituteAPI.EDUCATIONAL_INSTITUTE))
              .toString(),
          ['Test'].toString(),
        );
      });

      test('When called & http client throws Exceptions', () async {
        var _countriesApi = HttpCountryInstituteAPI();

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_countriesApi.getSuggestions('', ''),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
