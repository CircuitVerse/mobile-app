import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/models/ib/new_ib_topic_data.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';
import 'package:mobile_app/ui/views/new_ib/shared/components/recommendations_section.dart';
import 'package:mobile_app/ui/views/new_ib/shared/components/comments_section.dart';
import 'package:mobile_app/ui/views/new_ib/shared/components/under_construction_page.dart';
import 'package:mobile_app/ui/views/new_ib/pages/topic/components/topic_section_renderer.dart';

class IbTopicPage extends StatelessWidget {
  final NewIbLandingViewModel model;
  final NewIbTopicData topicData;
  final List<IbRecommendation> recommendations;
  final bool loadingRecommendations;

  const IbTopicPage({
    super.key,
    required this.model,
    required this.topicData,
    required this.recommendations,
    required this.loadingRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (model.isBusy(model.NEW_IB_FETCH_TOPIC)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state - display "Coming Soon" instead
    if (model.isError(model.NEW_IB_FETCH_TOPIC)) {
      return const UnderConstructionPage(
        title: 'Coming Soon',
        message: 'This topic is under development',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Topic Title Box
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
                  topicData.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: IbTheme.primaryHeadingColor(context),
                  ),
                ),
                if (topicData.metadata.author != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: IbTheme.textColor(context).withAlpha(179),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        topicData.metadata.author!,
                        style: TextStyle(
                          fontSize: 14,
                          color: IbTheme.textColor(context).withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Content sections
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IbTheme.textColor(context).withAlpha(13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: topicData.content.sections.map((section) {
                return TopicSectionRenderer(section: section);
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Key Concepts
          if (topicData.keyConcepts.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: IbTheme.getPrimaryColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: IbTheme.getPrimaryColor(context),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Key Concepts',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: IbTheme.primaryHeadingColor(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...topicData.keyConcepts.map((concept) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: IbTheme.getPrimaryColor(context),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  concept.concept,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: IbTheme.primaryHeadingColor(context),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  concept.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: IbTheme.textColor(context).withAlpha(204),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Related Topics
          if (topicData.relatedTopics.isNotEmpty) ...[
            Text(
              'Related Topics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
            const SizedBox(height: 16),
            ...topicData.relatedTopics.map((relatedTopic) {
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
                  onTap: () {
                    model.fetchTopicData(relatedTopic.path);
                  },
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
                            relatedTopic.title,
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
            }).toList(),
            const SizedBox(height: 32),
          ],

          // Recommendations
          RecommendationsSection(
            recommendations: recommendations,
            loading: loadingRecommendations,
          ),

          const SizedBox(height: 32),

          // Comments
          const CommentsSection(),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
