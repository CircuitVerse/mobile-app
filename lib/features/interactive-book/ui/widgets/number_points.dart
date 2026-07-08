import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/widgets_models/number_points.dart';
import 'package:mobile_app/features/interactive-book/ui/widgets/bullet_points.dart';
import 'package:mobile_app/ib_theme.dart';

class NumberPointsWidget extends StatelessWidget {
  final List<ItemModel> items;

  const NumberPointsWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _NumberedItem(
                number: index + 1,
                content: item.content,
                subItems: item.children,
                isLast: index == items.length - 1,
              );
            }).toList(),
      ),
    );
  }
}

class _NumberedItem extends StatelessWidget {
  final int number;
  final String content;
  final List<String> subItems;
  final bool isLast;

  const _NumberedItem({
    required this.number,
    required this.content,
    required this.subItems,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = IbTheme.getPrimaryColor(context);
    final textColor = IbTheme.textColor(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number badge
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(top: 1.0, right: 10.0),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1,
              ),
            ),
          ),
          // Content + sub-bullets
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: IbTheme.fontFamily,
                  ),
                ),
                if (subItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: BulletPointsWidget(bulletPoints: subItems),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
