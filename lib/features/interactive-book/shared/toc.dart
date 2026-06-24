import 'package:flutter/material.dart';

class TOC extends StatelessWidget {
  final List<dynamic> chapters;

  const TOC({super.key, required this.chapters});

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
            'CHAPTER CONTENTS',
            style: theme.textTheme.titleSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 20),
          ...chapters.map<Widget>(
            (chapter) => _ChapterSection(
              title: chapter.category ?? '',
              items: chapter.content ?? const [],
              linkColor: linkColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChapterSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final Color linkColor;

  const _ChapterSection({
    required this.title,
    required this.items,
    required this.linkColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bulletColor = theme.colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BulletedRow(
            bulletColor: bulletColor,
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
          if (items.isNotEmpty) const SizedBox(height: 16),
          ...items.map<Widget>(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 48, bottom: 16),
              child: _BulletedRow(
                bulletColor: bulletColor,
                child: Text(
                  item.name ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: linkColor,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    decoration: TextDecoration.underline,
                    decorationColor: bulletColor.withValues(alpha: 0.7),
                    decorationThickness: 1.5,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletedRow extends StatelessWidget {
  final Widget child;
  final Color bulletColor;

  const _BulletedRow({required this.child, required this.bulletColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 26,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 7, color: bulletColor),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
