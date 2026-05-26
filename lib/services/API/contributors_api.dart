import 'package:mobile_app/cache/cache_keys.dart';
import 'package:mobile_app/cache/cache_service.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class ContributorsApi {
  Future<List<CircuitVerseContributor>>? fetchContributors();
}

class HttpContributorsApi implements ContributorsApi {
  var headers = {'Content-Type': 'application/json'};

  // Shared cache instance — contributors never change within a session.
  final _cache = CacheService.instance;

  @override
  Future<List<CircuitVerseContributor>>? fetchContributors() async {
    //  Cache hit
    // The About screen can be visited multiple times from the drawer.
    // Without this cache the app hits GitHub's rate-limited API on every visit.
    final cached = _cache.get<List<CircuitVerseContributor>>(
      CacheKeys.contributors,
    );
    if (cached != null) return cached;

    //  Cache miss: fetch from network
    var _url =
        'https://api.github.com/repos/CircuitVerse/CircuitVerse/contributors';

    try {
      var _jsonResponse = await ApiUtils.get(_url, headers: headers);
      List<dynamic> contributorsList;

      if (_jsonResponse is List) {
        contributorsList = _jsonResponse;
      } else if (_jsonResponse is Map &&
          _jsonResponse.containsKey('contributors')) {
        contributorsList = _jsonResponse['contributors'] as List<dynamic>;
      } else {
        throw FormatException('Unexpected response format');
      }

      final contributors = circuitVerseContributorsFromList(contributorsList);

      // Cache for 12 hours — GitHub contributor counts are stable within a day.
      _cache.set(
        CacheKeys.contributors,
        contributors,
        ttl: CacheKeys.contributorsTtl,
      );

      return contributors;
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
