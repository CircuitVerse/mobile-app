import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/constants.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/notification.dart';
import 'package:mobile_app/utils/api_utils.dart';
import 'package:mobile_app/utils/app_exceptions.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';

abstract class NotificationsService {
  Future<List<Notification>?> fetchNotifications();

  Future markAsRead(String notificationId);

  Future markAllAsRead();
}

class NotificationsServiceImpl implements NotificationsService {
  var headers = {'Content-Type': 'application/json'};

  // Stream controller for notification refresh events
  static final StreamController<bool> _notificationRefreshController =
      StreamController<bool>.broadcast();

  static Stream<bool> get notificationRefreshStream =>
      _notificationRefreshController.stream;

  // Trigger refresh
  static void triggerRefresh() {
    _notificationRefreshController.add(true);
  }

  // Flutter Local Notifications Plugin
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize local notifications
  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
        // TODO: Navigate to notifications page if needed
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show notification in phone tray
  static Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;

    // If there's a notification payload, use it
    if (notification != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    } else if (message.data.isNotEmpty) {
      // If only data payload exists (no notification field), create notification from data
      final title = message.data['title'] ?? 'CircuitVerse';
      final body = message.data['body'] ?? 'You have a new notification';
      
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data.toString(),
      );
    }
    
    // Trigger refresh of notifications list
    triggerRefresh();
  }

  // Show local notification for new in-app notifications
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

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
