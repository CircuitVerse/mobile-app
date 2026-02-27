import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';

class NewIbDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final IbChapter? chapter;
  final IbChapter? selectedChapter;
  final bool isReturnHome;
  final VoidCallback onTap;

  const NewIbDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.chapter,
    required this.selectedChapter,
    this.isReturnHome = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = !isReturnHome && selectedChapter?.id == chapter?.id;

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
            icon,
            size: 24,
            color: isSelected
                ? IbTheme.getPrimaryColor(context)
                : IbTheme.textColor(context).withAlpha(179),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? IbTheme.getPrimaryColor(context)
                : IbTheme.textColor(context),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: IbTheme.textColor(context).withAlpha(153),
          ),
        ),
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
