import 'package:flutter/material.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';
import 'package:mobile_app/ui/views/new_ib/pages/chapter/chapter_index_page.dart';

/// Binary Representation Chapter Index Page
/// 
/// This is a specialized version of the chapter index page for the Binary Representation chapter.
/// Currently uses the generic ChapterIndexPage component, but can be customized if needed.
class BinaryRepresentationIndexPage extends StatelessWidget {
  final NewIbLandingViewModel model;
  final NewIbChapter chapter;
  final List<IbRecommendation> recommendations;
  final bool loadingRecommendations;

  const BinaryRepresentationIndexPage({
    super.key,
    required this.model,
    required this.chapter,
    required this.recommendations,
    required this.loadingRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    // For now, use the generic chapter index page
    // Can be customized later if Binary Representation needs special features
    return IbChapterIndexPage(
      model: model,
      chapter: chapter,
      recommendations: recommendations,
      loadingRecommendations: loadingRecommendations,
    );
  }
}
