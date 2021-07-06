import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum DatabaseBox {
  IB,
}

extension DatabaseBoxExt on DatabaseBox {
  String get inString => describeEnum(this);
}

abstract class DatabaseService {
  Future<void> init();

  Future<T> getData<T>(DatabaseBox box, String key, {T defaultValue});
  Future<void> setData<T>(DatabaseBox box, String key, T value);
}

class DatabaseServiceImpl implements DatabaseService {
  @override
  Future<void> init() async {
    // Hive DB setup
    await Hive.initFlutter();

    // Register Adapters for Hive
    // (TODO)
  }

  Future<Box> _openBox(DatabaseBox box) async {
    if (Hive.isBoxOpen(box.inString)) {
      return Hive.box(box.inString);
    }

    return await Hive.openBox(box.inString);
  }

  @override
  Future<T> getData<T>(DatabaseBox box, String key, {T defaultValue}) async {
    var openedBox = await _openBox(box);

    return openedBox.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> setData<T>(DatabaseBox box, String key, T value) async {
    var openedBox = await _openBox(box);

    return await openedBox.put(key, value);
  }
}
