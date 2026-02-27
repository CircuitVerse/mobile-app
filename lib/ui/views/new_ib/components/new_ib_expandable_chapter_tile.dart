import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_sub_chapter_tile.dart';

class NewIbExpandableChapterTile extends StatelessWidget {
  final IbChapter chapter;
  final IbChapter? selectedChapter;
  final Function(IbChapter) onChapterSelected;

  const NewIbExpandableChapterTile({
    super.key,
    required this.chapter,
    required this.selectedChapter,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedChapter?.id.startsWith(chapter.id) ?? false;
    final hasSelectedChild =
        chapter.items?.any((item) => item.id == selectedChapter?.id) ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected || hasSelectedChild
            ? IbTheme.getPrimaryColor(context).withAlpha(13)
            : Colors.transparent,
      ),
      child: Theme(
        data: IbTheme.getThemeData(context),
        child: ExpansionTile(
          initiallyExpanded: isSelected || hasSelectedChild,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected || hasSelectedChild
                  ? IbTheme.getPrimaryColor(context).withAlpha(51)
                  : IbTheme.textColor(context).withAlpha(13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.folder_rounded,
              size: 24,
              color: isSelected || hasSelectedChild
                  ? IbTheme.getPrimaryColor(context)
                  : IbTheme.textColor(context).withAlpha(179),
            ),
          ),
          title: GestureDetector(
            onTap: () => onChapterSelected(chapter),
            child: Text(
              chapter.value,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    isSelected || hasSelectedChild ? FontWeight.w600 : FontWeight.w500,
                color: isSelected || hasSelectedChild
                    ? IbTheme.getPrimaryColor(context)
                    : IbTheme.textColor(context),
              ),
            ),
          ),
          iconColor: IbTheme.textColor(context),
          collapsedIconColor: IbTheme.textColor(context).withAlpha(179),
          children: chapter.items
                  ?.map((subChapter) => NewIbSubChapterTile(
                        chapter: subChapter,
                        selectedChapter: selectedChapter,
                        onTap: () => onChapterSelected(subChapter),
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
