import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class TopicSteps extends StatelessWidget {
  final dynamic data;

  const TopicSteps({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Steps';
    final steps = data['steps'] as List<dynamic>? ?? [];
    final note = data['note'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: IbTheme.textColor(context).withAlpha(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: IbTheme.primaryHeadingColor(context),
            ),
          ),
          const SizedBox(height: 12),
          ...steps.map((step) {
            final stepNum = step['step'] as int? ?? 0;
            final description = step['description'] as String? ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: IbTheme.getPrimaryColor(context),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$stepNum',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: IbTheme.textColor(context).withAlpha(204),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (note != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: IbTheme.getPrimaryColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: IbTheme.getPrimaryColor(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      note,
                      style: TextStyle(
                        fontSize: 13,
                        color: IbTheme.textColor(context).withAlpha(204),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
