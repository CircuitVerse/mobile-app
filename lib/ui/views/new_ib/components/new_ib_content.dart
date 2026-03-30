import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/services/API/disqus_api.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';
import 'package:mobile_app/ui/views/new_ib/pages/home/home_page.dart';
import 'package:mobile_app/ui/views/new_ib/pages/chapter/chapter_index_page.dart';
import 'package:mobile_app/ui/views/new_ib/pages/topic/topic_page.dart';

class NewIbContent extends StatefulWidget {
  final NewIbLandingViewModel model;
  final Function(NewIbChapter?) onNavigate;

  const NewIbContent({
    super.key,
    required this.model,
    required this.onNavigate,
  });

  @override
  State<NewIbContent> createState() => _NewIbContentState();
}

class _NewIbContentState extends State<NewIbContent> {
  final DisqusApi _disqusApi = locator<DisqusApi>();
  List<IbRecommendation> _recommendations = [];
  bool _loadingRecommendations = false;

  @override
  void initState() {
    super.initState();
    print('NewIbContent: initState called, selectedChapter: ${widget.model.selectedChapter?.id}, isHome: ${widget.model.isHome}');
    // Load recommendations if we're on a chapter page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('NewIbContent: postFrameCallback, selectedChapter: ${widget.model.selectedChapter?.id}, isHome: ${widget.model.isHome}');
      if (widget.model.selectedChapter != null && !widget.model.isHome) {
        print('NewIbContent: Calling _loadRecommendations from initState');
        _loadRecommendations();
      }
    });
  }

  @override
  void didUpdateWidget(NewIbContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('NewIbContent: didUpdateWidget called');
    print('NewIbContent: Old chapter: ${oldWidget.model.selectedChapter?.id}');
    print('NewIbContent: New chapter: ${widget.model.selectedChapter?.id}');
    // Load recommendations when chapter changes
    if (widget.model.selectedChapter != oldWidget.model.selectedChapter &&
        widget.model.selectedChapter != null &&
        !widget.model.isHome) {
      print('NewIbContent: Calling _loadRecommendations from didUpdateWidget');
      _loadRecommendations();
    }
    // Also load recommendations if we just switched to chapter index page
    if (widget.model.topicData == null && 
        oldWidget.model.topicData != null &&
        widget.model.selectedChapter != null &&
        !widget.model.isHome &&
        _recommendations.isEmpty) {
      print('NewIbContent: Calling _loadRecommendations after returning from topic');
      _loadRecommendations();
    }
  }

  Future<void> _loadRecommendations() async {
    if (widget.model.selectedChapter == null) return;

    setState(() {
      _loadingRecommendations = true;
    });

    try {
      final baseUrl = 'https://learn.circuitverse.org';
      final chapterPath = widget.model.selectedChapter!.path;
      final fullUrl = '$baseUrl/$chapterPath/';

      print('NewIbContent: Loading recommendations for: $fullUrl');

      final recommendations = await _disqusApi.fetchRecommendations(fullUrl);

      print('NewIbContent: Received ${recommendations.length} recommendations');

      if (mounted) {
        setState(() {
          _recommendations = recommendations;
          _loadingRecommendations = false;
        });
      }
    } catch (e) {
      print('NewIbContent: Error loading recommendations: $e');
      // Use fallback recommendations if API fails
      if (mounted) {
        setState(() {
          _recommendations = [
            IbRecommendation(
              title: 'Binary Arithmetic',
              url: 'https://learn.circuitverse.org/docs/binary-representation/binary-arithmetic/',
              image: 'https://learn.circuitverse.org/images/binary-arithmetic.png',
            ),
            IbRecommendation(
              title: 'Signed Numbers',
              url: 'https://learn.circuitverse.org/docs/binary-representation/signed-numbers/',
              image: 'https://learn.circuitverse.org/images/signed-numbers.png',
            ),
            IbRecommendation(
              title: 'Logic Gates',
              url: 'https://learn.circuitverse.org/docs/logic-gates/',
              image: 'https://learn.circuitverse.org/images/logic-gates.png',
            ),
            IbRecommendation(
              title: 'Boolean Algebra',
              url: 'https://learn.circuitverse.org/docs/boolean-algebra/',
              image: 'https://learn.circuitverse.org/images/boolean-algebra.png',
            ),
            IbRecommendation(
              title: 'Combinational Logic',
              url: 'https://learn.circuitverse.org/docs/combinational-logic/',
              image: 'https://learn.circuitverse.org/images/combinational-logic.png',
            ),
          ];
          _loadingRecommendations = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show home page if no chapter selected or home is selected
    if (widget.model.isHome || widget.model.selectedChapter == null) {
      return IbHomePage(
        model: widget.model,
        onNavigate: widget.onNavigate,
      );
    }

    // Show topic page if topic data is available
    if (widget.model.topicData != null) {
      // Load recommendations for topic page if not already loaded
      if (!_loadingRecommendations && _recommendations.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_loadingRecommendations && _recommendations.isEmpty) {
            print('NewIbContent: Calling _loadRecommendations from build for topic');
            _loadRecommendations();
          }
        });
      }

      return IbTopicPage(
        model: widget.model,
        topicData: widget.model.topicData!,
        recommendations: _recommendations,
        loadingRecommendations: _loadingRecommendations,
      );
    }

    // Load recommendations for chapter index page if not already loaded
    if (!_loadingRecommendations && _recommendations.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_loadingRecommendations && _recommendations.isEmpty) {
          print('NewIbContent: Calling _loadRecommendations from build for chapter index');
          _loadRecommendations();
        }
      });
    }

    // Show chapter index page
    return IbChapterIndexPage(
      model: widget.model,
      chapter: widget.model.selectedChapter!,
      recommendations: _recommendations,
      loadingRecommendations: _loadingRecommendations,
    );
  }
}
