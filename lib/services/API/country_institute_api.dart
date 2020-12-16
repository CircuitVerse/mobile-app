import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class CountryInstituteAPI {
  static const String COUNTRY = 'country';
  static const String EDUCATIONAL_INSTITUTE = 'educational institute';
  Future<dynamic> getSuggestions(String query, String url);
}

class HttpCountryInstituteAPI implements CountryInstituteAPI {
  List<dynamic> data;

  @override
  Future<dynamic> getSuggestions(String query, String value) async {
    var url = (value == CountryInstituteAPI.COUNTRY)
        ? 'https://restcountries.eu/rest/v2/all'
        : 'http://universities.hipolabs.com/search?';

    var headers = {'Content-Type': 'application/json'};
    try {
      ApiUtils.addTokenToHeaders(headers);
      data = await ApiUtils.get(
        url,
        headers: headers,
      );

      var matches = [];

      for (var i = 0; i < data.length; i++) {
        matches.add(data[i]['name']);
      }

      matches
          .retainWhere((s) => s.toLowerCase().startsWith(query.toLowerCase()));

      return matches;
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    } catch (e) {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
