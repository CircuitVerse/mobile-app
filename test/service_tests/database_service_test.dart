import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/database_service.dart';

void main() {
  group('DatabaseService Test -', () {
    setUpAll(() async {
      await setupLocator();
    });

    void initHive() {
      var path = Directory.current.path;
      Hive.init(path + '/test/hive_testing_path');
    }

    test('Set and Get data from a box', () async {
      final db = locator<DatabaseService>();

      await db.init();
      initHive();

      await db.setData(DatabaseBox.IB, 'test', 'test value');
      var expectedData = await db.getData(DatabaseBox.IB, 'test');

      expect(expectedData, 'test value');
    });

    test('Get non-existent data from a box', () async {
      final db = locator<DatabaseService>();

      await db.init();
      initHive();

      var expectedData = await db.getData(DatabaseBox.IB, 'test-2');
      expect(expectedData, null);
    });

    test('Get default value from non-existent data from a box', () async {
      final db = locator<DatabaseService>();

      await db.init();
      initHive();

      var expectedData =
          await db.getData(DatabaseBox.IB, 'test-3', defaultValue: 'test');
      expect(expectedData, 'test');
    });
  });
}
