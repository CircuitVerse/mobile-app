import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ApiUtilsTests -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    test('When http method called & raises SocketException', () {
      ApiUtils.client = MockClient((_) => throw const SocketException(''));

      expect(() => ApiUtils.get('/'), throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.post('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.put('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.patch('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.patchMutipart('/', headers: {}, files: []),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.delete('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
    });

    test('When http method called & raises HttpException', () {
      ApiUtils.client = MockClient((_) => throw const HttpException(''));

      expect(() => ApiUtils.get('/'), throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.post('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.put('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.patch('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.patchMutipart('/', headers: {}, files: []),
          throwsA(isInstanceOf<Failure>()));
      expect(() => ApiUtils.delete('/', headers: {}),
          throwsA(isInstanceOf<Failure>()));
    });

    test('When http method called & status success', () async {
      ApiUtils.client = MockClient((_) => Future.value(Response('', 200)));

      expect(await ApiUtils.get('/'), {});
      expect(await ApiUtils.post('/', headers: {}), {});
      expect(await ApiUtils.put('/', headers: {}), {});
      expect(await ApiUtils.patch('/', headers: {}), {});
      expect(await ApiUtils.patchMutipart('/', headers: {}, files: []), {});
      expect(await ApiUtils.delete('/', headers: {}), {});
    });

    group('jsonResponse -', () {
      group('When status code 200/201/202/204 -', () {
        test('When body is empty', () {
          var _jsonResponse = ApiUtils.jsonResponse(Response('', 200));

          expect(_jsonResponse, {});
        });

        test('When body is not empty', () {
          var _jsonResponse =
              ApiUtils.jsonResponse(Response('{"body": "body"}', 200));

          expect(_jsonResponse, {'body': 'body'});
        });
      });

      test('When status code is 400', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 400)),
          throwsA(isInstanceOf<BadRequestException>()),
        );
      });

      test('When status code is 401', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 401)),
          throwsA(isInstanceOf<UnauthorizedException>()),
        );
      });

      test('When status code is 403', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 403)),
          throwsA(isInstanceOf<ForbiddenException>()),
        );
      });

      test('When status code is 404', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 404)),
          throwsA(isInstanceOf<NotFoundException>()),
        );
      });

      test('When status code is 409', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 409)),
          throwsA(isInstanceOf<ConflictException>()),
        );
      });

      test('When status code is 422', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 422)),
          throwsA(isInstanceOf<UnprocessableIdentityException>()),
        );
      });

      test('When status code is 500', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 500)),
          throwsA(isInstanceOf<InternalServerErrorException>()),
        );
      });

      test('When status code is 503', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 503)),
          throwsA(isInstanceOf<ServiceUnavailableException>()),
        );
      });

      test('When status code differs from above', () {
        expect(
          () => ApiUtils.jsonResponse(Response('', 510)),
          throwsA(isInstanceOf<FetchDataException>()),
        );
      });
    });

    group('addTokenToHeaders -', () {
      test('When called, adds Authorization header', () {
        var _localStorageServiceMock = getAndRegisterLocalStorageServiceMock();
        when(_localStorageServiceMock.token).thenAnswer((_) => 'token');

        var _headers = <String, String>{};
        ApiUtils.addTokenToHeaders(_headers);

        expect(_headers.containsKey('Authorization'), true);
        expect(_headers.containsValue('Token token'), true);
      });
    });
  });
}
