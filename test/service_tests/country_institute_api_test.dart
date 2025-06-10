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
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
          (_) => Future.value(Response(jsonEncode(mockCountries), 200)),
        );

        // IMPORTANT: Disable fallback for testing
        var _countryApi = HttpCountryInstituteAPI(useFallbackOnError: false);

        // Test with query 'ta' - should return empty if no matches
        expect(
          await _countryApi.getCountries('ta'),
          [], // Expect empty list if mockCountries doesn't contain 'ta'
        );

        // Test with query 't' - should return ['Test'] if mockCountries contains it
        expect(
          await _countryApi.getCountries('t'),
          ['Test'], // This assumes mockCountries has a country with 'Test' name
        );

        // Test with empty query - should return empty list (per your API logic)
        expect(
          await _countryApi.getCountries(''),
          [], // Empty query returns empty list
        );
      });

      test('When called & http client throws Exceptions', () async {
        // IMPORTANT: Disable fallback for testing
        var _countriesApi = HttpCountryInstituteAPI(useFallbackOnError: false);

        ApiUtils.client = MockClient((_) => throw Exception('Network error'));

        // Since useFallbackOnError is false, it should throw a Failure
        expect(
          () => _countriesApi.getCountries('test'),
          throwsA(isA<Failure>()),
        );
      });
    });
  });

  group('InstituteApi -', () {
    group('fetchInstitutes -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
          (_) => Future.value(Response(jsonEncode(mockInstitutes), 200)),
        );

        // IMPORTANT: Disable fallback for testing
        var _countryApi = HttpCountryInstituteAPI(useFallbackOnError: false);

        // Since mockInstitutes contains "Test":
        // - 'ta' shouldn't match "Test" (returns empty)
        // - 'Te' should match "Test" (case insensitive)
        // - 'Test' should match "Test" (exact match)
        expect(await _countryApi.getInstitutes('ta'), []);
        expect(await _countryApi.getInstitutes('Te'), ['Test']);
        expect(await _countryApi.getInstitutes('Test'), ['Test']);
        expect(await _countryApi.getInstitutes(''), []);
      });

      test('When called & http client throws Exceptions', () async {
        // IMPORTANT: Disable fallback for testing
        var _countriesApi = HttpCountryInstituteAPI(useFallbackOnError: false);

        ApiUtils.client = MockClient((_) => throw Exception('Network error'));

        // Since useFallbackOnError is false, it should throw a Failure
        expect(
          () => _countriesApi.getInstitutes('test'),
          throwsA(isA<Failure>()),
        );
      });
    });
  });
}
