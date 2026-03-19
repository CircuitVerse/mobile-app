import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageService Test -', () {
    late LocalStorageService storage;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      storage = locator<LocalStorageService>();
    });

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('isLoggedIn flag is stored and retrieved correctly', () {
      expect(storage.isLoggedIn, false); // Default value should be false

      storage.isLoggedIn = true;
      expect(storage.isLoggedIn, true);

      storage.isLoggedIn = false;
      expect(storage.isLoggedIn, false);
    });

    test('token is stored and retrieved correctly', () {
      expect(storage.token, null); // Default

      storage.token = 'mock_jwt_token';
      expect(storage.token, 'mock_jwt_token');

      // Test deletion
      storage.token = null;
      expect(storage.token, null);
    });

    test('currentUser is stored and retrieved correctly', () {
      expect(storage.currentUser, null);

      var mockUser = User(
        data: Data(
          id: '1',
          type: 'user',
          attributes: UserAttributes(
            name: 'Test User',
            email: 'test@example.com',
            subscribed: false,
            admin: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      );

      storage.currentUser = mockUser;
      expect(storage.currentUser?.data.attributes.name, 'Test User');

      // Test deletion
      storage.currentUser = null;
      expect(storage.currentUser, null);
    });
  });
}
