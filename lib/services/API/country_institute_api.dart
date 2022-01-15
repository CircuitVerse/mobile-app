import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class CountryInstituteAPI {
  Future<dynamic> getCountries(String query);
  Future<dynamic> getInstitutes(String query);
}

class HttpCountryInstituteAPI implements CountryInstituteAPI {
  List<dynamic> data;

  Future<dynamic> _fetchAPI(String query, String url) async {
    try {
      data = await ApiUtils.get(
        url,
      );

      var matches = [];

      for (var i = 0; i < data.length; i++) {
        matches.add(data[i]['name']);
      }

      matches.retainWhere(
        (s) => s.toLowerCase().startsWith(
              query.toLowerCase(),
            ),
      );

      return matches;
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    } catch (e) {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<dynamic> getCountries(String query) async {
    var url = 'https://restcountries.eu/rest/v2/all';
    try {
      return _fetchAPI(query, url);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    } catch (e) {
      throw Failure(Constants.genericFAILURE);
    }
  }

  @override
  Future<dynamic> getInstitutes(String query) async {
    var url = 'http://universities.hipolabs.com/search?';
    try {
      return _fetchAPI(query, url);
    } on Exception {
      throw Failure(Constants.genericFAILURE);
    } catch (e) {
      throw Failure(Constants.genericFAILURE);
    }
  }
}
