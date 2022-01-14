import 'dart:convert';

import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class ContributorsApi {
  Future<List<CircuitVerseContributor>>? fetchContributors();
}

class HttpContributorsApi implements ContributorsApi {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<List<CircuitVerseContributor>>? fetchContributors() async {
    var _url =
        'https://api.github.com/repos/CircuitVerse/CircuitVerse/contributors';

    try {
      var _jsonResponse = await ApiUtils.get(_url, headers: headers);
      return circuitVerseContributorsFromJson(jsonEncode(_jsonResponse));
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
