import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data/mock_user.dart';
import '../setup/test_helpers.dart';

void main() {
  group('UsersApiTest -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    group('login -', () {
      test('When called & http client returns accepted response', () async {
        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"token": "token"}', 202)));
        var _usersApi = HttpUsersApi();

        var _token = await _usersApi.login('test@test.com', 'test');
        expect(_token, 'token');
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(_usersApi.login('test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_usersApi.login('test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.login('test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.login('test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('signup -', () {
      test('When called & http client returns created response', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"token": "token"}', 201)));
        expect(
            await _usersApi.signup('test', 'test@test.com', 'test'), 'token');
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw ConflictException(''));
        expect(_usersApi.signup('test', 'test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.signup('test', 'test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.signup('test', 'test@test.com', 'test'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('oauthLogin -', () {
      test('When called & http client returns accepted response', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"token": "token"}', 201)));
        expect(
            await _usersApi.oauthLogin(accessToken: 'token', provider: 'test'),
            'token');
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_usersApi.oauthLogin(accessToken: 'token', provider: 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.oauthLogin(accessToken: 'token', provider: 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.oauthLogin(accessToken: 'token', provider: 'test'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('oauthSignup -', () {
      test('When called & http client returns created response', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient(
            (_) => Future.value(Response('{"token": "token"}', 202)));
        expect(
            await _usersApi.oauthSignup(accessToken: 'token', provider: 'test'),
            'token');
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw ConflictException(''));
        expect(_usersApi.oauthSignup(accessToken: 'token', provider: 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.oauthSignup(accessToken: 'token', provider: 'test'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.oauthSignup(accessToken: 'token', provider: 'test'),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('fetchUser -', () {
      test('When called & http client returns success response', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient(
            (_) => Future.value(Response(json.encode(mockUser), 200)));
        expect((await _usersApi.fetchUser('1')).toString(),
            User.fromJson(mockUser).toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.fetchUser('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_usersApi.fetchUser('1'), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.fetchUser('1'), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('fetchCurrentUser -', () {
      test('When called & http client returns success response', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient(
            (_) => Future.value(Response(json.encode(mockUser), 200)));
        expect((await _usersApi.fetchCurrentUser()).toString(),
            User.fromJson(mockUser).toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.fetchCurrentUser(), throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.fetchCurrentUser(), throwsA(isInstanceOf<Failure>()));
      });
    });

    group('updateProfile -', () {
      test('When called & http client returns accepted response', () async {
        var _localStorage = getAndRegisterLocalStorageServiceMock();
        when(_localStorage.currentUser).thenReturn(User.fromJson(mockUser));
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient(
            (_) => Future.value(Response(json.encode(mockUser), 202)));
        expect(
            (await _usersApi.updateProfile(
                    'Test User', 'Gurukul', 'India', true, null, false))
                .toString(),
            User.fromJson(mockUser).toString());
      });

      test('When called & http client throws Exceptions', () async {
        var _localStorage = getAndRegisterLocalStorageServiceMock();
        when(_localStorage.currentUser).thenReturn(User.fromJson(mockUser));
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(
            _usersApi.updateProfile(
                'Test User', 'Gurukul', 'India', true, null, false),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
            _usersApi.updateProfile(
                'Test User', 'Gurukul', 'India', true, null, false),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('sendResetPasswordInstructions -', () {
      test('When called & http client returns success response', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) =>
            Future.value(Response('{"message": "instructions sent"}', 200)));
        expect(await _usersApi.sendResetPasswordInstructions('test@test.com'),
            true);
      });

      test('When called & http client throws Exceptions', () async {
        var _usersApi = HttpUsersApi();

        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(_usersApi.sendResetPasswordInstructions('test@test.com'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw const FormatException(''));
        expect(_usersApi.sendResetPasswordInstructions('test@test.com'),
            throwsA(isInstanceOf<Failure>()));

        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(_usersApi.sendResetPasswordInstructions('test@test.com'),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
