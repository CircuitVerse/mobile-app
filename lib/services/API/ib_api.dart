import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/utils/api_utils.dart';

abstract class IbApi {
  Future<List> fetchApiPage({String id});
  Future<IbRawPageData> fetchRawPageData({String id});
}

class HttpIbApi implements IbApi {
  @override
  Future<List> fetchApiPage({String id = ''}) async {
    var _url = id == ''
        ? '${EnvironmentConfig.IB_API_BASE_URL}.json'
        : '${EnvironmentConfig.IB_API_BASE_URL}/${id}.json';

    try {
      var _jsonResponse = await ApiUtils.get(_url);
      return _jsonResponse;
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future<IbRawPageData> fetchRawPageData({String id = 'index.md'}) async {
    var _url = '${EnvironmentConfig.IB_API_BASE_URL}/${id}';

    try {
      var _jsonResponse = await ApiUtils.get(_url);
      return IbRawPageData.fromJson(_jsonResponse);
    } on FormatException {
      throw Failure(Constants.BAD_RESPONSE_FORMAT);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
