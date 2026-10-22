import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/notification.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/notifications_service.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data/mock_notifications.dart';

class LocalStorageServiceMock extends Mock implements LocalStorageService {
  @override
  String? get token => 'test_token';
}

void main() {
  group('NotificationsServiceTest -', () {
    setUpAll(() {
      if (locator.isRegistered<LocalStorageService>()) {
        locator.unregister<LocalStorageService>();
      }
      locator.registerSingleton<LocalStorageService>(LocalStorageServiceMock());
    });
    tearDownAll(() {
      if (locator.isRegistered<LocalStorageService>()) {
        locator.unregister<LocalStorageService>();
      }
    });

    final expectedNotifications = (mockNotifications['data'] as List)
        .map((e) => Notification.fromJson(e as Map<String, dynamic>))
        .toList();

    group('fetchNotifications -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
          (_) => Future.value(Response(jsonEncode(mockNotifications), 200)),
        );
        final notificationsService = NotificationsServiceImpl();

        final result = await notificationsService.fetchNotifications();

        expect(result, isNotNull);
        expect(result!.length, expectedNotifications.length);
        expect(result[0].id, expectedNotifications[0].id);
        expect(result[0].attributes.type, expectedNotifications[0].attributes.type);
        expect(result[1].id, expectedNotifications[1].id);
      });

      test('When called & http client throws Exceptions', () async {
        final notificationsService = NotificationsServiceImpl();

        // 401 Unauthorized
        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(
          notificationsService.fetchNotifications(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.UNAUTHENTICATED,
            ),
          ),
        );

        // 403 Forbidden
        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
          notificationsService.fetchNotifications(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.UNAUTHORIZED,
            ),
          ),
        );

        // 404 NotFound
        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
          notificationsService.fetchNotifications(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.NOTIFICATION_NOT_FOUND,
            ),
          ),
        );

        // Generic Exception
        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
          notificationsService.fetchNotifications(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.GENERIC_FAILURE,
            ),
          ),
        );
      });
    });

    group('markAsRead -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
          (_) => Future.value(Response('{}', 200)),
        );
        final notificationsService = NotificationsServiceImpl();

        await expectLater(
          notificationsService.markAsRead('1'),
          completes,
        );
      });

      test('When called & http client throws Exceptions', () async {
        final notificationsService = NotificationsServiceImpl();

        // 401 Unauthorized
        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(
          notificationsService.markAsRead('1'),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.UNAUTHENTICATED,
            ),
          ),
        );

        // 403 Forbidden
        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
          notificationsService.markAsRead('1'),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.UNAUTHORIZED,
            ),
          ),
        );

        // 404 NotFound
        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
          notificationsService.markAsRead('1'),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.NOTIFICATION_NOT_FOUND,
            ),
          ),
        );

        // Generic Exception
        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
          notificationsService.markAsRead('1'),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.GENERIC_FAILURE,
            ),
          ),
        );
      });
    });

    group('markAllAsRead -', () {
      test('When called & http client returns success response', () async {
        ApiUtils.client = MockClient(
          (_) => Future.value(Response('{}', 200)),
        );
        final notificationsService = NotificationsServiceImpl();

        await expectLater(
          notificationsService.markAllAsRead(),
          completes,
        );
      });

      test('When called & http client throws Exceptions', () async {
        final notificationsService = NotificationsServiceImpl();

        // 401 Unauthorized
        ApiUtils.client = MockClient((_) => throw UnauthorizedException(''));
        expect(
          notificationsService.markAllAsRead(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.UNAUTHENTICATED,
            ),
          ),
        );

        // 403 Forbidden
        ApiUtils.client = MockClient((_) => throw ForbiddenException(''));
        expect(
          notificationsService.markAllAsRead(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.UNAUTHORIZED,
            ),
          ),
        );

        // 404 NotFound
        ApiUtils.client = MockClient((_) => throw NotFoundException(''));
        expect(
          notificationsService.markAllAsRead(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.NOTIFICATION_NOT_FOUND,
            ),
          ),
        );

        // Generic Exception
        ApiUtils.client = MockClient((_) => throw Exception(''));
        expect(
          notificationsService.markAllAsRead(),
          throwsA(
            predicate(
              (e) =>
                  e is Failure &&
                  e.message == Constants.GENERIC_FAILURE,
            ),
          ),
        );
      });
    });
  });
}
