import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class CountryInstituteAPI {
  Future<List<String>> getCountries(String query);
  Future<List<String>> getInstitutes(String query);
}

class HttpCountryInstituteAPI implements CountryInstituteAPI {
  // Cache to avoid repeated API calls
  List<dynamic>? _cachedCountries;
  final Map<String, List<String>> _instituteCache = {};

  // Flag to control fallback behavior for testing
  final bool _useFallbackOnError;

  HttpCountryInstituteAPI({bool useFallbackOnError = true})
    : _useFallbackOnError = useFallbackOnError;

  Future<List<String>> _fetchCountries(String query) async {
    try {
      // Return empty list for empty queries to allow TypeAhead to work properly
      if (query.trim().isEmpty) {
        return [];
      }

      // Cache countries data if not already cached
      if (_cachedCountries == null) {
        try {
          final url = 'https://restcountries.com/v3.1/all';
          final response = await ApiUtils.get(url);

          if (response is List) {
            _cachedCountries = response;
          } else {
            throw Failure(Constants.BAD_RESPONSE_FORMAT);
          }
        } catch (e) {
          if (e is Failure) {
            rethrow;
          }
          throw Failure(
            '${Constants.NO_INTERNET_CONNECTION}. ${Constants.GENERIC_FAILURE}',
          );
        }
      }

      final matches = <String>[];
      final lowerQuery = query.toLowerCase().trim();

      for (var country in _cachedCountries!) {
        try {
          String? countryName;

          if (country is Map) {
            if (country.containsKey('name') && country['name'] is Map) {
              final nameMap = country['name'] as Map;
              if (nameMap.containsKey('common') &&
                  nameMap['common'] is String) {
                countryName = nameMap['common'].toString().trim();
              }
            } else if (country.containsKey('name') &&
                country['name'] is String) {
              countryName = country['name'].toString().trim();
            }
          } else if (country is String) {
            countryName = country.trim();
          }

          if (countryName != null && countryName.isNotEmpty) {
            final lowerName = countryName.toLowerCase();
            if (lowerName.contains(lowerQuery)) {
              matches.add(countryName);
            }
          }
        } catch (_) {
          continue;
        }
      }

      // Sort matches: exact matches first, then starts with, then contains
      matches.sort((a, b) {
        final aLower = a.toLowerCase();
        final bLower = b.toLowerCase();

        if (aLower == lowerQuery) return -1;
        if (bLower == lowerQuery) return 1;
        if (aLower.startsWith(lowerQuery) && !bLower.startsWith(lowerQuery)) {
          return -1;
        }
        if (!aLower.startsWith(lowerQuery) && bLower.startsWith(lowerQuery)) {
          return 1;
        }

        return a.compareTo(b);
      });

      return matches.take(10).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('${Constants.GENERIC_FAILURE} while fetching countries');
    }
  }

  Future<List<String>> _fetchInstitutes(String query) async {
    try {
      // Return empty list for empty queries to allow TypeAhead to work properly
      if (query.trim().isEmpty) {
        return [];
      }

      final trimmedQuery = query.toLowerCase().trim();

      // Check cache first
      if (_instituteCache.containsKey(trimmedQuery)) {
        return _instituteCache[trimmedQuery]!;
      }

      // Try multiple sources for better coverage
      final matches = <String>{}; // Use Set to avoid duplicates

      // Source 1: Hipolabs API
      try {
        final url1 =
            'http://universities.hipolabs.com/search?name=${Uri.encodeComponent(query)}';
        final data1 = await ApiUtils.get(url1);

        if (data1 is List) {
          for (var institute in data1) {
            if (institute is Map && institute.containsKey('name')) {
              final name = institute['name'];
              if (name is String && name.trim().isNotEmpty) {
                matches.add(name.trim());
              }
            }
          }
        } else {
          throw Failure(Constants.BAD_RESPONSE_FORMAT);
        }
      } catch (e) {
        if (e is Failure) {
          // If fallback is disabled (for testing), rethrow the error
          if (!_useFallbackOnError) {
            rethrow;
          }
        } else {
          // For non-Failure exceptions, convert to Failure and handle appropriately
          if (!_useFallbackOnError) {
            throw Failure(
              '${Constants.NO_INTERNET_CONNECTION}. ${Constants.GENERIC_FAILURE}',
            );
          }
        }
        // Continue to try other sources even if this fails (when fallback is enabled)
      }

      // Source 2: Famous universities fallback (only if fallback is enabled)
      if (_useFallbackOnError) {
        final famousUniversities = _getFamousUniversities();
        for (var university in famousUniversities) {
          if (university.toLowerCase().contains(trimmedQuery)) {
            matches.add(university);
          }
        }
      }

      final matchesList = matches.toList();

      // Sort matches similar to countries
      matchesList.sort((a, b) {
        final aLower = a.toLowerCase();
        final bLower = b.toLowerCase();

        if (aLower == trimmedQuery) return -1;
        if (bLower == trimmedQuery) return 1;
        if (aLower.startsWith(trimmedQuery) &&
            !bLower.startsWith(trimmedQuery)) {
          return -1;
        }
        if (!aLower.startsWith(trimmedQuery) &&
            bLower.startsWith(trimmedQuery)) {
          return 1;
        }

        return a.compareTo(b);
      });

      final result = matchesList.take(15).toList();

      // Cache the results
      _instituteCache[trimmedQuery] = result;

      return result;
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('${Constants.GENERIC_FAILURE} while fetching institutes');
    }
  }

  // Fallback countries list
  List<String> _getFallbackCountries() {
    return [
      'Afghanistan',
      'Albania',
      'Algeria',
      'Andorra',
      'Angola',
      'Antigua and Barbuda',
      'Argentina',
      'Armenia',
      'Australia',
      'Austria',
      'Azerbaijan',
      'Bahamas',
      'Bahrain',
      'Bangladesh',
      'Barbados',
      'Belarus',
      'Belgium',
      'Belize',
      'Benin',
      'Bhutan',
      'Bolivia',
      'Bosnia and Herzegovina',
      'Botswana',
      'Brazil',
      'Brunei',
      'Bulgaria',
      'Burkina Faso',
      'Burundi',
      'Cabo Verde',
      'Cambodia',
      'Cameroon',
      'Canada',
      'Central African Republic',
      'Chad',
      'Chile',
      'China',
      'Colombia',
      'Comoros',
      'Congo',
      'Costa Rica',
      'Croatia',
      'Cuba',
      'Cyprus',
      'Czech Republic',
      'Denmark',
      'Djibouti',
      'Dominica',
      'Dominican Republic',
      'Ecuador',
      'Egypt',
      'El Salvador',
      'Equatorial Guinea',
      'Eritrea',
      'Estonia',
      'Eswatini',
      'Ethiopia',
      'Fiji',
      'Finland',
      'France',
      'Gabon',
      'Gambia',
      'Georgia',
      'Germany',
      'Ghana',
      'Greece',
      'Grenada',
      'Guatemala',
      'Guinea',
      'Guinea-Bissau',
      'Guyana',
      'Haiti',
      'Honduras',
      'Hungary',
      'Iceland',
      'India',
      'Indonesia',
      'Iran',
      'Iraq',
      'Ireland',
      'Israel',
      'Italy',
      'Jamaica',
      'Japan',
      'Jordan',
      'Kazakhstan',
      'Kenya',
      'Kiribati',
      'Korea, North',
      'Korea, South',
      'Kosovo',
      'Kuwait',
      'Kyrgyzstan',
      'Laos',
      'Latvia',
      'Lebanon',
      'Lesotho',
      'Liberia',
      'Libya',
      'Liechtenstein',
      'Lithuania',
      'Luxembourg',
      'Madagascar',
      'Malawi',
      'Malaysia',
      'Maldives',
      'Mali',
      'Malta',
      'Marshall Islands',
      'Mauritania',
      'Mauritius',
      'Mexico',
      'Micronesia',
      'Moldova',
      'Monaco',
      'Mongolia',
      'Montenegro',
      'Morocco',
      'Mozambique',
      'Myanmar',
      'Namibia',
      'Nauru',
      'Nepal',
      'Netherlands',
      'New Zealand',
      'Nicaragua',
      'Niger',
      'Nigeria',
      'North Macedonia',
      'Norway',
      'Oman',
      'Pakistan',
      'Palau',
      'Panama',
      'Papua New Guinea',
      'Paraguay',
      'Peru',
      'Philippines',
      'Poland',
      'Portugal',
      'Qatar',
      'Romania',
      'Russia',
      'Rwanda',
      'Saint Kitts and Nevis',
      'Saint Lucia',
      'Saint Vincent and the Grenadines',
      'Samoa',
      'San Marino',
      'Sao Tome and Principe',
      'Saudi Arabia',
      'Senegal',
      'Serbia',
      'Seychelles',
      'Sierra Leone',
      'Singapore',
      'Slovakia',
      'Slovenia',
      'Solomon Islands',
      'Somalia',
      'South Africa',
      'South Sudan',
      'Spain',
      'Sri Lanka',
      'Sudan',
      'Suriname',
      'Sweden',
      'Switzerland',
      'Syria',
      'Taiwan',
      'Tajikistan',
      'Tanzania',
      'Thailand',
      'Togo',
      'Tonga',
      'Trinidad and Tobago',
      'Tunisia',
      'Turkey',
      'Turkmenistan',
      'Tuvalu',
      'Uganda',
      'Ukraine',
      'United Arab Emirates',
      'United Kingdom',
      'United States',
      'Uruguay',
      'Uzbekistan',
      'Vanuatu',
      'Vatican City',
      'Venezuela',
      'Vietnam',
    ];
  }

  List<String> _getFamousUniversities() {
    return [
      'Harvard University',
      'Stanford University',
      'Massachusetts Institute of Technology',
      'University of Cambridge',
      'University of Oxford',
      'California Institute of Technology',
      'ETH Zurich',
      'University of Chicago',
      'University College London',
      'Imperial College London',
      'National University of Singapore',
      'Princeton University',
      'Nanyang Technological University',
      'Tsinghua University',
      'Peking University',
      'Yale University',
      'Cornell University',
      'Columbia University',
      'University of Edinburgh',
      'University of Pennsylvania',
      'University of Michigan',
      'Johns Hopkins University',
      'University of Toronto',
      'University of Hong Kong',
      'University of Tokyo',
      'University of California, Berkeley',
      'University of Manchester',
      'Northwestern University',
      'University of Sydney',
      'University of Melbourne',
      'University of British Columbia',
      'University of California, Los Angeles',
      'University of New South Wales',
      'Duke University',
      'University of Queensland',
      'Carnegie Mellon University',
      'New York University',
      'University of Washington',
      'University of Bristol',
      'King\'s College London',
      'Delft University of Technology',
      'University of Warwick',
      'Brown University',
      'University of Amsterdam',
      'University of Glasgow',
      'University of Illinois at Urbana-Champaign',
      'University of Texas at Austin',
      'University of Wisconsin-Madison',
      'University of Zurich',
      'Boston University',
    ];
  }

  @override
  Future<List<String>> getCountries(String query) async {
    try {
      return await _fetchCountries(query);
    } on Failure {
      // Only use fallback if enabled
      if (_useFallbackOnError) {
        return _getFallbackCountries()
            .where(
              (country) => country.toLowerCase().contains(query.toLowerCase()),
            )
            .take(10)
            .toList();
      }
      rethrow;
    } catch (e) {
      if (_useFallbackOnError) {
        return _getFallbackCountries()
            .where(
              (country) => country.toLowerCase().contains(query.toLowerCase()),
            )
            .take(10)
            .toList();
      }
      throw Failure('${Constants.GENERIC_FAILURE} while fetching countries');
    }
  }

  @override
  Future<List<String>> getInstitutes(String query) async {
    try {
      return await _fetchInstitutes(query);
    } on Failure {
      // Only use fallback if enabled
      if (_useFallbackOnError) {
        return _getFamousUniversities()
            .where((uni) => uni.toLowerCase().contains(query.toLowerCase()))
            .take(15)
            .toList();
      }
      rethrow;
    } catch (e) {
      if (_useFallbackOnError) {
        return _getFamousUniversities()
            .where((uni) => uni.toLowerCase().contains(query.toLowerCase()))
            .take(15)
            .toList();
      }
      throw Failure('${Constants.GENERIC_FAILURE} while fetching institutes');
    }
  }

  // Method to clear cache if needed
  void clearCache() {
    _cachedCountries = null;
    _instituteCache.clear();
  }

  Future<void> debugCountryStructure() async {
    try {
      final url = 'https://restcountries.com/v3.1/all';
      final data = await ApiUtils.get(url);

      if (data is List && data.isNotEmpty) {
        final firstCountry = data[0];
        if (firstCountry is Map) {
          if (firstCountry.containsKey('name')) {
            // Structure is valid
          }
        }
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('${Constants.GENERIC_FAILURE} during debug');
    }
  }
}
