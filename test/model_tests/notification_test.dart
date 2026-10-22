import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/notification.dart';

import '../setup/test_data/mock_notifications.dart';

void main() {
  group('NotificationModelTest -', () {
    test('fromJson - Notification with null read_at', () {
      final notification = Notification.fromJson(mockNotification);

      expect(notification.id, '1');
      expect(notification.type, 'notifications');
      expect(notification.attributes.recipientType, 'User');
      expect(notification.attributes.recipientId, 1);
      expect(notification.attributes.type, 'StarNotification');
      expect(notification.attributes.readAt, isNull);
      expect(
        notification.attributes.createdAt,
        DateTime.parse('2023-01-01T00:00:00.000Z'),
      );
      expect(
        notification.attributes.updatedAt,
        DateTime.parse('2023-01-01T00:00:00.000Z'),
      );
      expect(notification.attributes.unread, true);

      // Params - User
      expect(notification.attributes.params.user.data.id, '1');
      expect(
        notification.attributes.params.user.data.attributes.name,
        'Test User',
      );
      expect(
        notification.attributes.params.user.data.attributes.email,
        'test@circuitverse.org',
      );

      // Params - Project
      expect(notification.attributes.params.project.id, 1);
      expect(notification.attributes.params.project.authorId, 1);
      expect(notification.attributes.params.project.accessType, 'Public');
      expect(notification.attributes.params.project.name, 'Test Circuit');
      expect(notification.attributes.params.project.projectSubmission, false);
      expect(notification.attributes.params.project.description, 'Test description');
      expect(notification.attributes.params.project.slug, 'test-circuit');
      expect(notification.attributes.params.project.view, 10);
      expect(
        notification.attributes.params.project.imagePreview?['url'],
        'https://circuitverse.org/preview.png',
      );
    });

    test('fromJson - Notification with non-null read_at and null image_preview', () {
      final notification = Notification.fromJson(
        mockNotifications['data'][1] as Map<String, dynamic>,
      );

      expect(notification.id, '2');
      expect(notification.type, 'notifications');
      expect(notification.attributes.recipientType, 'User');
      expect(notification.attributes.recipientId, 1);
      expect(notification.attributes.type, 'ForkNotification');
      expect(
        notification.attributes.readAt,
        DateTime.parse('2023-01-02T00:00:00.000Z'),
      );
      expect(notification.attributes.unread, false);
      expect(notification.attributes.params.project.imagePreview, isNull);
    });
  });
}
