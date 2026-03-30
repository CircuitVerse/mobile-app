import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';

class NewIbSubChapterTile extends StatelessWidget {
  final NewIbSubChapter subChapter;
  final bool isSelected;
  final VoidCallback onTap;

  const NewIbSubChapterTile({
    super.key,
    required this.subChapter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: ListTile(
        onTap: onTap,
        contentPadding:
            const EdgeInsets.only(left: 56, right: 16, top: 0, bottom: 0),
        visualDensity: const VisualDensity(vertical: -2),
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? IbTheme.getPrimaryColor(context)
                    : IbTheme.textColor(context).withAlpha(128),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                subChapter.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? IbTheme.getPrimaryColor(context)
                      : IbTheme.textColor(context).withAlpha(204),
                ),
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.circle,
                size: 8,
                color: IbTheme.getPrimaryColor(context),
              )
            : null,
      ),
    );
  }
}
