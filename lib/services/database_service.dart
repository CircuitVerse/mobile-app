import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';

enum DatabaseBox {
  Metadata,
  IB,
}

List<TypeAdapter> DatabaseAdapters = <TypeAdapter>[
  IbRawPageDataAdapter(),
];

extension DatabaseBoxExt on DatabaseBox {
  String get inString => describeEnum(this);
}

abstract class DatabaseService {
  Future<void> init();

  Future<bool> isExpired(String key);
  Future<T> getData<T>(DatabaseBox box, String key, {T defaultValue});
  Future<void> setData(DatabaseBox box, String key, dynamic value,
      {bool expireData});
}

class DatabaseServiceImpl implements DatabaseService {
  final int _timeoutHours = 6;

  @override
  Future<void> init() async {
    // Hive DB setup
    try {
      await Hive.initFlutter();
    } catch (e) {
      debugPrint('Hive Initialization Failed');
    }

    // Register Adapters for Hive
    for (var adapter in DatabaseAdapters) {
      Hive.registerAdapter(adapter);
    }
  }

  Future<Box> _openBox(DatabaseBox box) async {
    if (Hive.isBoxOpen(box.inString)) {
      return Hive.box(box.inString);
    }

    return await Hive.openBox(box.inString);
  }

  @override
  Future<bool> isExpired(String key) async {
    var data = await getData<DateTime?>(DatabaseBox.Metadata, key);

    return data == null ||
        data.isBefore(
          DateTime.now().subtract(
            Duration(hours: _timeoutHours),
          ),
        );
  }

  @override
  Future<T> getData<T>(DatabaseBox box, String key, {T? defaultValue}) async {
    var openedBox = await _openBox(box);

    return openedBox.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> setData(DatabaseBox box, String key, dynamic value,
      {bool expireData = false}) async {
    var openedBox = await _openBox(box);

    if (expireData) {
      await setData(DatabaseBox.Metadata, key, DateTime.now());
    }

    await openedBox.put(key, value);
  }
}
