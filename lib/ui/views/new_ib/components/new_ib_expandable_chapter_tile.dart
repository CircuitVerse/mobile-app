import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_sub_chapter_tile.dart';

class NewIbExpandableChapterTile extends StatelessWidget {
  final NewIbChapter chapter;
  final NewIbChapter? selectedChapter;
  final NewIbSubChapter? selectedSubChapter;
  final Function(NewIbChapter) onChapterSelected;
  final Function(NewIbChapter, NewIbSubChapter) onSubChapterSelected;

  const NewIbExpandableChapterTile({
    super.key,
    required this.chapter,
    required this.selectedChapter,
    required this.selectedSubChapter,
    required this.onChapterSelected,
    required this.onSubChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isParentSelected = selectedChapter?.id == chapter.id && selectedSubChapter == null;
    final hasSelectedChild = selectedChapter?.id == chapter.id && selectedSubChapter != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isParentSelected || hasSelectedChild
            ? IbTheme.getPrimaryColor(context).withAlpha(13)
            : Colors.transparent,
      ),
      child: Theme(
        data: IbTheme.getThemeData(context),
        child: ExpansionTile(
          initiallyExpanded: isParentSelected || hasSelectedChild,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isParentSelected || hasSelectedChild
                  ? IbTheme.getPrimaryColor(context).withAlpha(51)
                  : IbTheme.textColor(context).withAlpha(13),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.folder_rounded,
              size: 24,
              color: isParentSelected || hasSelectedChild
                  ? IbTheme.getPrimaryColor(context)
                  : IbTheme.textColor(context).withAlpha(179),
            ),
          ),
          title: GestureDetector(
            onTap: () => onChapterSelected(chapter),
            child: Text(
              chapter.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    isParentSelected || hasSelectedChild ? FontWeight.w600 : FontWeight.w500,
                color: isParentSelected || hasSelectedChild
                    ? IbTheme.getPrimaryColor(context)
                    : IbTheme.textColor(context),
              ),
            ),
          ),
          iconColor: IbTheme.textColor(context),
          collapsedIconColor: IbTheme.textColor(context).withAlpha(179),
          children: chapter.children
                  ?.map((subChapter) => NewIbSubChapterTile(
                        subChapter: subChapter,
                        isSelected: selectedSubChapter?.id == subChapter.id,
                        onTap: () => onSubChapterSelected(chapter, subChapter),
                      ))
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
