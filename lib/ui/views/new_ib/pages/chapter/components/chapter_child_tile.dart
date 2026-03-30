import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_chapter_index_data.dart';

class ChapterChildTile extends StatelessWidget {
  final NewIbChapterChild child;
  final VoidCallback onTap;

  const ChapterChildTile({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: IbTheme.textColor(context).withAlpha(26),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: IbTheme.getPrimaryColor(context).withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.article_rounded,
                  size: 24,
                  color: IbTheme.getPrimaryColor(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  child.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: IbTheme.primaryHeadingColor(context),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: IbTheme.textColor(context).withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
