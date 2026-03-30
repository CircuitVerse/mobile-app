import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/models/ib/new_ib_chapter_index_data.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';
import 'package:mobile_app/ui/views/new_ib/shared/components/recommendations_section.dart';
import 'package:mobile_app/ui/views/new_ib/shared/components/comments_section.dart';
import 'package:mobile_app/ui/views/new_ib/shared/components/under_construction_page.dart';
import 'package:mobile_app/ui/views/new_ib/pages/chapter/components/chapter_child_tile.dart';

class IbChapterIndexPage extends StatelessWidget {
  final NewIbLandingViewModel model;
  final NewIbChapter chapter;
  final List<IbRecommendation> recommendations;
  final bool loadingRecommendations;

  const IbChapterIndexPage({
    super.key,
    required this.model,
    required this.chapter,
    required this.recommendations,
    required this.loadingRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (model.isBusy(model.NEW_IB_FETCH_CHAPTER_INDEX)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state - display "Coming Soon" instead
    if (model.isError(model.NEW_IB_FETCH_CHAPTER_INDEX)) {
      return const UnderConstructionPage(
        title: 'Coming Soon',
        message: 'This chapter is under development',
      );
    }

    // Get chapter index data
    final chapterData = model.chapterIndexData;
    if (chapterData == null) {
      return const Center(child: Text('No chapter data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Chapter Title and Description Box
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: IbTheme.getPrimaryColor(context).withAlpha(26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapterData.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: IbTheme.primaryHeadingColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  chapterData.description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: IbTheme.textColor(context).withAlpha(204),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Content sections
          if (chapterData.content.sections.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: IbTheme.textColor(context).withAlpha(13),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: chapterData.content.sections.map((section) {
                  return _buildChapterSection(context, section);
                }).toList(),
              ),
            ),

          const SizedBox(height: 24),

          // Children/Sub-chapters list
          if (chapterData.children.isNotEmpty) ...[
            Text(
              'Topics in this chapter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
            const SizedBox(height: 16),
            ...chapterData.children.map((child) => ChapterChildTile(
              child: child,
              onTap: () => model.fetchTopicData(child.path),
            )),
          ],

          const SizedBox(height: 32),

          // Also on Interactive Book (Recommendations)
          RecommendationsSection(
            recommendations: recommendations,
            loading: loadingRecommendations,
          ),

          const SizedBox(height: 32),

          // Comments Section
          const CommentsSection(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildChapterSection(BuildContext context, NewIbChapterSection section) {
    switch (section.type) {
      case 'heading':
        if (section.level == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              section.text ?? '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          );
        } else if (section.level == 2) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: Text(
              section.text ?? '',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          );
        } else if (section.level == 3) {
          return Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Text(
              section.text ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          );
        }
        return const SizedBox.shrink();

      case 'paragraph':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            section.text ?? '',
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: IbTheme.textColor(context).withAlpha(204),
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
