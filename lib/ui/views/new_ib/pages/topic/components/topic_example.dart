import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class TopicExample extends StatelessWidget {
  final dynamic data;

  const TopicExample({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Example';
    final dataRaw = data['data'];
    final exampleData = dataRaw != null
        ? (dataRaw is Map<String, dynamic>
            ? dataRaw
            : Map<String, dynamic>.from(dataRaw as Map))
        : <String, dynamic>{};

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.getPrimaryColor(context).withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: IbTheme.getPrimaryColor(context).withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: IbTheme.getPrimaryColor(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IbTheme.primaryHeadingColor(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...exampleData.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${entry.key}: ${entry.value}',
                style: TextStyle(
                  fontSize: 14,
                  color: IbTheme.textColor(context).withAlpha(204),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
