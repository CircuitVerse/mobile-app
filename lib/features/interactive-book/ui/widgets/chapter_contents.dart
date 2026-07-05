import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/models.dart';

class ChapterContentsWidget extends StatelessWidget {
  final List<ChapterItemsModel> items;

  const ChapterContentsWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            'IN THIS CHAPTER',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              letterSpacing: 2.2,
            ),
          ),

          const SizedBox(height: 24),

          ...items.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Category Heading
                  Text(
                    category.category,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Category Items
                  ...category.content.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              right: 12,
                            ),
                            child: Icon(
                              Icons.circle,
                              size: 7,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: linkColor,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                decorationColor: theme
                                    .colorScheme
                                    .onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}