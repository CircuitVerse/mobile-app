import 'package:flutter/material.dart';

class TocWidget extends StatelessWidget {
  final List<String> chapters;

  const TocWidget({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    debugPrint("Rendering TOC with chapters: $chapters");
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final linkColor =
        theme.brightness == Brightness.dark
            ? const Color(0xFF00E8B3)
            : const Color(0xFF007D68);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Table of Contents',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 20),
          ...chapters.map<Widget>(
            (chapter) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 12),
                  child: Icon(
                    Icons.circle,
                    size: 7,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Expanded(
                  child: Text(
                    chapter,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: linkColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
