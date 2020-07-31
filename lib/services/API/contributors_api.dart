import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class ContributorsApi {
  Future<List<CircuitVerseContributors>> fetchContributors();
}

class HttpContributorsApi implements ContributorsApi {
  var headers = {'Content-Type': 'application/json'};
  http.Client client = http.Client();

  @override
  Future<List<CircuitVerseContributors>> fetchContributors() async {
    var _url =
        'https://api.github.com/repos/CircuitVerse/CircuitVerse/contributors';
    try {
      var _jsonResponse = await ApiUtils.get(_url, headers: headers);
      var _listOfContributors =
          circuitVerseContributorsFromJson(jsonEncode(_jsonResponse));
      return _listOfContributors;
    } on FormatException catch (e) {
      print(e.message);
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception catch (e) {
      print(e.toString());
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
