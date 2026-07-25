import 'package:flutter/material.dart';

class TocWidget extends StatelessWidget {
  final List<String> chapters;
  final Function(int) onTap;

  const TocWidget({super.key, required this.chapters, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
          ...chapters.asMap().entries.map<Widget>(
            (entry) => InkWell(
              onTap: () => onTap(entry.key),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
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
                        entry.value,
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
            ),
          ),
        ],
      ),
    );
  }
}
