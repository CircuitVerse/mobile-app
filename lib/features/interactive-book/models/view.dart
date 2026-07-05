import 'package:flutter/foundation.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/text.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/chapter_contents/cc.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/toc.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/clipboard.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/table/table.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/binary_simulator.dart';

abstract class ViewModel {
  final String type;
  final String? subType;

  const ViewModel({required this.type, this.subType});

  factory ViewModel.fromJson(Map<String, dynamic> json) {
    final String? rawSubType = json['sub_type'] ?? json['sub-type'];
    debugPrint("Widget type: ${json['type']}, sub_type: $rawSubType, keys: ${json.keys.toList()}");
    if (rawSubType != null) json['sub_type'] = rawSubType;
    switch (json['type']) {
      case 'text':
        return TextModel.fromJson(json);
      case 'widget':
        final String subType = rawSubType ?? '';
        switch (subType) {
          case 'chapter_contents':
            return ChapterContentsModel.fromJson(json);
          case 'toc':
            return TocModel.fromJson(json);
          case 'clipboard':
            return ClipboardModel.fromJson(json);
          case 'table':
            return TableModel.fromJson(json);
          case 'binary-simulator':
            return BinarySimulatorModel.fromJson(json);
          default:
            debugPrint('Unhandled widget sub_type: $subType — skipping');
            return _UnknownViewModel(type: json['type'] ?? '', subType: subType);
        }
      default:
        debugPrint('Unhandled view type: ${json['type']} — skipping');
        return _UnknownViewModel(type: json['type'] ?? '');
    }
  }
}

class _UnknownViewModel extends ViewModel {
  const _UnknownViewModel({required super.type, super.subType});
}
