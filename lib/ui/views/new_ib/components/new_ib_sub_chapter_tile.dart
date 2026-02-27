import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';

class NewIbSubChapterTile extends StatelessWidget {
  final IbChapter chapter;
  final IbChapter? selectedChapter;
  final VoidCallback onTap;

  const NewIbSubChapterTile({
    super.key,
    required this.chapter,
    required this.selectedChapter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedChapter?.id == chapter.id;

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
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? IbTheme.getPrimaryColor(context)
                    : IbTheme.textColor(context).withAlpha(102),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                chapter.value,
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
