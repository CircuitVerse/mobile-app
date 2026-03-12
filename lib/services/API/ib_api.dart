import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_json_page_data.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/database_service.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class IbApi {
  Future<List<Map<String, dynamic>>>? fetchApiPage({String id});
  Future<IbRawPageData>? fetchRawPageData({String id});
  Future<IbJsonPageData>? fetchJsonPageData({String path});
}

class HttpIbApi implements IbApi {
  /// Database Service
  final DatabaseService _db = locator<DatabaseService>();

  @override
  Future<List<Map<String, dynamic>>>? fetchApiPage({String id = ''}) async {
    var _url =
        id == ''
            ? EnvironmentConfig.IB_API_BASE_URL
            : '${EnvironmentConfig.IB_API_BASE_URL}/$id';

    try {
      if (await _db.isExpired(_url)) {
        var _jsonResponse = await ApiUtils.get(_url);
        _jsonResponse = <Map<String, dynamic>>[..._jsonResponse];
        await _db.setData(
          DatabaseBox.IB,
          _url,
          _jsonResponse,
          expireData: true,
        );
        return _jsonResponse;
      } else {
        var data = await _db.getData<List<dynamic>>(DatabaseBox.IB, _url);
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<IbRawPageData>? fetchRawPageData({String id = 'index.md'}) async {
    var _url = '${EnvironmentConfig.IB_API_BASE_URL}/$id';

    try {
      var _jsonResponse = await ApiUtils.get(_url, utfDecoder: true);
      return IbRawPageData.fromJson(_jsonResponse);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<IbJsonPageData>? fetchJsonPageData({
    String path = 'docs/binary-representation/index',
  }) async {
    final url = '${EnvironmentConfig.IB_JSON_API_BASE_URL}/$path.json';

    try {
      if (await _db.isExpired(url)) {
        final jsonResponse = await ApiUtils.get(url);
        await _db.setData(DatabaseBox.IB, url, jsonResponse, expireData: true);
        return IbJsonPageData.fromJson(jsonResponse as Map<String, dynamic>);
      } else {
        final data = await _db.getData<Map<String, dynamic>>(
          DatabaseBox.IB,
          url,
        );
        return IbJsonPageData.fromJson(data);
      }
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception catch (e) {
      throw Failure('Failed to fetch JSON page data: ${e.toString()}');
    }
  }
}
