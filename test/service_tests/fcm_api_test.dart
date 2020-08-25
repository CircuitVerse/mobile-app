import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/services/API/fcm_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

import '../setup/test_helpers.dart';

void main() {
  group('FcmApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    group('sendToken -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"message": "received"}', 200)));
        var _fcmApi = HttpFCMApi();

        expect(await _fcmApi.sendToken('token'), 'received');
      });

      test('When called & http client throws Exceptions', () async {
        var _fcmApi = HttpFCMApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_fcmApi.sendToken('token'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client =
            MockClient((_) => throw UnprocessableIdentityException(''));
        expect(_fcmApi.sendToken('token'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_fcmApi.sendToken('token'), throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
