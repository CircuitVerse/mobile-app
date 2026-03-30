import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';

class NewIbSimpleChapterTile extends StatelessWidget {
  final NewIbChapter chapter;
  final bool isSelected;
  final VoidCallback onTap;

  const NewIbSimpleChapterTile({
    super.key,
    required this.chapter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected
            ? IbTheme.getPrimaryColor(context).withAlpha(26)
            : Colors.transparent,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected
                ? IbTheme.getPrimaryColor(context).withAlpha(51)
                : IbTheme.textColor(context).withAlpha(13),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.article_rounded,
            size: 24,
            color: isSelected
                ? IbTheme.getPrimaryColor(context)
                : IbTheme.textColor(context).withAlpha(179),
          ),
        ),
        title: Text(
          chapter.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? IbTheme.getPrimaryColor(context)
                : IbTheme.textColor(context),
          ),
        ),
        subtitle: chapter.description != null && chapter.description!.isNotEmpty
            ? Text(
                chapter.description!,
                style: TextStyle(
                  fontSize: 12,
                  color: IbTheme.textColor(context).withAlpha(128),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: isSelected
            ? Icon(
                Icons.chevron_right_rounded,
                color: IbTheme.getPrimaryColor(context),
              )
            : null,
      ),
    );
  }
}
