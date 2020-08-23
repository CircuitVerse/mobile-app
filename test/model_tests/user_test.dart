import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/user.dart';

import '../setup/test_data/mock_user.dart';

void main() {
  group('UserTest -', () {
    test('fromJson', () {
      var _user = User.fromJson(mockUser);

      expect(_user.data.id, '1');
      expect(_user.data.type, 'user');
      expect(_user.data.attributes.name, 'Test User');
      expect(_user.data.attributes.email, 'test@test.com');
      expect(_user.data.attributes.subscribed, true);
      expect(_user.data.attributes.createdAt,
          DateTime.parse('2020-02-15T17:20:06.155Z'));
      expect(_user.data.attributes.updatedAt,
          DateTime.parse('2020-08-15T03:16:50.702Z'));
      expect(_user.data.attributes.admin, false);
      expect(_user.data.attributes.country, 'India');
      expect(_user.data.attributes.educationalInstitute, 'Gurukul');
    });

    test('toJson', () {
      var _user = User(
        data: Data(
          id: '1',
          type: 'user',
          attributes: UserAttributes(
            name: 'Test User',
            email: 'test@test.com',
            subscribed: true,
            createdAt: DateTime(2020, 8, 15),
            updatedAt: DateTime(2020, 8, 15),
            admin: false,
            country: 'India',
            educationalInstitute: 'Gurukul',
          ),
        ),
      ).toJson();

      expect(_user['data']['id'], '1');
      expect(_user['data']['type'], 'user');
      expect(_user['data']['attributes']['name'], 'Test User');
      expect(_user['data']['attributes']['email'], 'test@test.com');
      expect(_user['data']['attributes']['subscribed'], true);
      expect(_user['data']['attributes']['created_at'],
          DateTime(2020, 8, 15).toIso8601String());
      expect(_user['data']['attributes']['updated_at'],
          DateTime(2020, 8, 15).toIso8601String());
      expect(_user['data']['attributes']['admin'], false);
      expect(_user['data']['attributes']['country'], 'India');
      expect(_user['data']['attributes']['educational_institute'], 'Gurukul');
    });
  });
}
