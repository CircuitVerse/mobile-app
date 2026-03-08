import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_footer.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_header.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_section.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_tile.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_expandable_chapter_tile.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_simple_chapter_tile.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';

class NewIbDrawer extends StatelessWidget {
  final IbLandingViewModel model;
  final IbChapter? selectedChapter;
  final Function(IbChapter?) onChapterSelected;

  const NewIbDrawer({
    super.key,
    required this.model,
    required this.selectedChapter,
    required this.onChapterSelected,
  });

  List<Widget> _buildChapters(BuildContext context) {
    var widgets = <Widget>[];

    for (var chapter in model.chapters) {
      if (chapter.items != null && chapter.items!.isNotEmpty) {
        widgets.add(
          NewIbExpandableChapterTile(
            chapter: chapter,
            selectedChapter: selectedChapter,
            onChapterSelected: (chapter) {
              onChapterSelected(chapter);
              Get.back();
            },
          ),
        );
      } else {
        widgets.add(
          NewIbSimpleChapterTile(
            chapter: chapter,
            selectedChapter: selectedChapter,
            onTap: () {
              onChapterSelected(chapter);
              Get.back();
            },
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              IbTheme.getPrimaryColor(context).withAlpha(13),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            const NewIbDrawerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  const NewIbDrawerSection(title: 'Navigation'),
                  NewIbDrawerTile(
                    icon: Icons.arrow_back_rounded,
                    title: 'Return Home',
                    subtitle: 'Back to CircuitVerse',
                    chapter: null,
                    selectedChapter: selectedChapter,
                    isReturnHome: true,
                    onTap: () {
                      Get.back(); // Close drawer
                      if (Get.key.currentState?.canPop() ?? false) {
                        Get.back(); // Navigate back if possible
                      }
                    },
                  ),
                  NewIbDrawerTile(
                    icon: Icons.home_rounded,
                    title: 'Home',
                    subtitle: 'Interactive Book home',
                    chapter: model.homeChapter,
                    selectedChapter: selectedChapter,
                    onTap: () {
                      onChapterSelected(model.homeChapter);
                      Get.back();
                    },
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  const NewIbDrawerSection(title: 'Chapters'),
                  if (model.isBusy(model.IB_FETCH_CHAPTERS))
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Loading chapters...'),
                        ],
                      ),
                    )
                  else if (model.isError(model.IB_FETCH_CHAPTERS))
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 20,
                            color: IbTheme.textColor(context).withAlpha(128),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Failed to load chapters',
                              style: TextStyle(
                                color: IbTheme.textColor(
                                  context,
                                ).withAlpha(179),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._buildChapters(context),
                ],
              ),
            ),
            const NewIbDrawerFooter(),
          ],
        ),
      ),
    );
  }
}
