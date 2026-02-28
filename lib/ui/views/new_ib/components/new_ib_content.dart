import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_chapter_page.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_home_page.dart';

class NewIbContent extends StatelessWidget {
  final IbChapter? selectedChapter;
  final IbChapter homeChapter;
  final Function(IbChapter?) onNavigate;

  const NewIbContent({
    super.key,
    required this.selectedChapter,
    required this.homeChapter,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Show home page for home chapter
    if (selectedChapter?.id == homeChapter.id) {
      return NewIbHomePage(chapter: selectedChapter!);
    }

    // Show chapter page for other chapters
    if (selectedChapter != null) {
      return NewIbChapterPage(
        key: ValueKey(selectedChapter!.id), // Unique key per chapter
        chapter: selectedChapter!,
        onNavigate: onNavigate,
      );
    }

    // Show placeholder if no chapter selected
    return _buildPlaceholder(
      context: context,
      icon: Icons.auto_stories_rounded,
      title: 'Welcome to Interactive Book',
      description:
          'Select a chapter from the menu to begin your learning journey.',
    );
  }

  Widget _buildPlaceholder({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    IbTheme.getPrimaryColor(context).withAlpha(26),
                    IbTheme.getPrimaryColor(context).withAlpha(13),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: IbTheme.getPrimaryColor(context).withAlpha(26),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 80,
                color: IbTheme.getPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: IbTheme.textColor(context).withAlpha(179),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: IbTheme.getPrimaryColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: IbTheme.getPrimaryColor(context).withAlpha(77),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: IbTheme.getPrimaryColor(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: IbTheme.getPrimaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
