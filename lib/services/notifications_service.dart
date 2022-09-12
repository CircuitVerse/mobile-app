import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/notification.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';

abstract class NotificationsService {
  Future<List<Notification>?> fetchNotifications();

  Future markAsRead(String notificationId);

  Future markAllAsRead();
}

class NotificationsServiceImpl implements NotificationsService {
  var headers = {'Content-Type': 'application/json'};

  @override
  Future<List<Notification>?> fetchNotifications() async {
    const endpoint = '/notifications';
    const uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      final response = await ApiUtils.get(uri, headers: headers);
      List<Notification> notif = [];
      for (final res in response['data']) {
        notif.add(Notification.fromJson(res));
      }

      return notif;
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future markAsRead(String notificationId) async {
    final endpoint = '/notifications/mark_as_read/$notificationId';
    final uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      await ApiUtils.patch(uri, headers: headers);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }

  @override
  Future markAllAsRead() async {
    const endpoint = '/notifications/mark_all_as_read';
    const uri = EnvironmentConfig.CV_API_BASE_URL + endpoint;

    try {
      ApiUtils.addTokenToHeaders(headers);
      await ApiUtils.get(uri, headers: headers);
    } on ForbiddenException {
      throw Failure(Constants.UNAUTHORIZED);
    } on NotFoundException {
      throw Failure(Constants.GROUP_NOT_FOUND);
    } on Exception {
      throw Failure(Constants.GENERIC_FAILURE);
    }
  }
}
