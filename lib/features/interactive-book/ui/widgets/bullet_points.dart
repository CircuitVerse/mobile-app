import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class BulletPointsWidget extends StatelessWidget {
  final List<String> bulletPoints;

  const BulletPointsWidget({super.key, required this.bulletPoints});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            bulletPoints.map((entry) {
              return _BulletItem(
                text: entry,
                isLast: bulletPoints.indexOf(entry) == bulletPoints.length - 1,
              );
            }).toList(),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final bool isLast;

  const _BulletItem({required this.text, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final bulletColor = IbTheme.getPrimaryColor(context);
    final textColor = IbTheme.textColor(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bullet dot aligned with the first line of text
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 10.0),
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: bulletColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.55,
                color: textColor,
                fontFamily: IbTheme.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
