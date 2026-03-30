import 'package:flutter/material.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/models/ib/new_ib_topic_data.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';
import 'package:mobile_app/ui/views/new_ib/pages/topic/topic_page.dart';

/// Binary Numbers Topic Page
/// 
/// This is a specialized version of the topic page for the Binary Numbers topic
/// under the Binary Representation chapter.
/// Currently uses the generic TopicPage component, but can be customized if needed.
class BinaryNumbersPage extends StatelessWidget {
  final NewIbLandingViewModel model;
  final NewIbTopicData topicData;
  final List<IbRecommendation> recommendations;
  final bool loadingRecommendations;

  const BinaryNumbersPage({
    super.key,
    required this.model,
    required this.topicData,
    required this.recommendations,
    required this.loadingRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    // For now, use the generic topic page
    // Can be customized later if Binary Numbers needs special features
    // (e.g., additional interactive widgets, custom visualizations, etc.)
    return IbTopicPage(
      model: model,
      topicData: topicData,
      recommendations: recommendations,
      loadingRecommendations: loadingRecommendations,
    );
  }
}
