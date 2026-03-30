import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_footer.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_header.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_section.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer_tile.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_simple_chapter_tile.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_expandable_chapter_tile.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';

class NewIbDrawer extends StatelessWidget {
  final NewIbLandingViewModel model;
  final Function(NewIbChapter?) onChapterSelected;
  final VoidCallback onHomeSelected;

  const NewIbDrawer({
    super.key,
    required this.model,
    required this.onChapterSelected,
    required this.onHomeSelected,
  });

  List<Widget> _buildChapters(BuildContext context) {
    return model.chapters.map((chapter) {
      // If chapter has children, use expandable tile
      if (chapter.children != null && chapter.children!.isNotEmpty) {
        return NewIbExpandableChapterTile(
          chapter: chapter,
          selectedChapter: model.selectedChapter,
          selectedSubChapter: model.selectedSubChapter,
          onChapterSelected: (chapter) {
            model.selectChapter(chapter);
            model.setHome(false);
            onChapterSelected(chapter);
            Get.back();
          },
          onSubChapterSelected: (parentChapter, subChapter) {
            model.selectSubChapter(parentChapter, subChapter);
            model.setHome(false);
            // You can handle sub-chapter navigation here
            Get.back();
          },
        );
      } else {
        // Simple tile for chapters without children
        return NewIbSimpleChapterTile(
          chapter: chapter,
          isSelected: model.selectedChapter?.id == chapter.id && model.selectedSubChapter == null,
          onTap: () {
            model.selectChapter(chapter);
            model.setHome(false);
            onChapterSelected(chapter);
            Get.back();
          },
        );
      }
    }).toList();
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
                    isSelected: false,
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
                    isSelected: model.isHome,
                    onTap: () {
                      model.selectChapter(null);
                      model.setHome(true);
                      onHomeSelected();
                      Get.back();
                    },
                  ),
                  const Divider(height: 24, indent: 16, endIndent: 16),
                  const NewIbDrawerSection(title: 'Chapters'),
                  if (model.isBusy(model.NEW_IB_FETCH_DRAWER))
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
                  else if (model.isError(model.NEW_IB_FETCH_DRAWER))
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
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
                                    color: IbTheme.textColor(context).withAlpha(179),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            model.errorMessageFor(model.NEW_IB_FETCH_DRAWER) ?? 'Unknown error',
                            style: TextStyle(
                              fontSize: 12,
                              color: IbTheme.textColor(context).withAlpha(128),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => model.fetchDrawerData(),
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: IbTheme.getPrimaryColor(context),
                              foregroundColor: Colors.white,
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
            NewIbDrawerFooter(metadata: model.metadata),
          ],
        ),
      ),
    );
  }
}
