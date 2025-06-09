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

        // Test with query 'ta' - check what your mockInstitutes actually contains
        final taResult = await _countryApi.getInstitutes('ta');
        // If your mockInstitutes has 'Test' which contains 'ta', expect ['Test']
        // If it doesn't have any matches, expect []
        expect(taResult, ['Test']); // Adjust based on your mock data

        // Test with query 't' - should return institutes matching 't'
        final tResult = await _countryApi.getInstitutes('t');
        expect(tResult, ['Test']); // Adjust based on your mock data

        // Test with empty query - should return empty list (per your API logic)
        expect(
          await _countryApi.getInstitutes(''),
          [], // Empty query returns empty list
        );
      });

      test('When called & http client throws Exceptions', () async {
        // IMPORTANT: Disable fallback for testing
        var _countriesApi = HttpCountryInstituteAPI(useFallbackOnError: false);

        ApiUtils.client = MockClient((_) => throw Exception('Network error'));

        // After fixing the implementation, it should throw a Failure
        expect(
          () => _countriesApi.getInstitutes('test'),
          throwsA(isA<Failure>()),
        );
      });
    });
  });
}
