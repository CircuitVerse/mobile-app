import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class CountryInstituteAPI {
  Future<dynamic> getCountries(String query);
  Future<dynamic> getInstitutes(String query);
}

class HttpCountryInstituteAPI implements CountryInstituteAPI {
  late List<dynamic> data;

  Future<dynamic> _fetchAPI(String query, String url) async {
    try {
      data = await ApiUtils.get(url);

      var matches = [];
      final bool isCountryApi = url.contains('countries');

      for (var i = 0; i < data.length; i++) {
        var name = data[i]['name'];
        if (isCountryApi) name = name['common'];
        matches.add(name);
      }

      matches.retainWhere(
        (s) => s.toLowerCase().startsWith(
              query.toLowerCase(),
            ),
      );

      return matches;
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    } catch (e) {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<dynamic> getCountries(String query) async {
    var url = 'https://restcountries.com/v3.1/all';
    try {
      return _fetchAPI(query, url);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    } catch (e) {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<dynamic> getInstitutes(String query) async {
    var url = 'http://universities.hipolabs.com/search?';
    try {
      return _fetchAPI(query, url);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    } catch (e) {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
