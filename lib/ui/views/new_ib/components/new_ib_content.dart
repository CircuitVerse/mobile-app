import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_recommendation.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/models/ib/new_ib_home_data.dart';
import 'package:mobile_app/models/ib/new_ib_chapter_index_data.dart';
import 'package:mobile_app/services/API/disqus_api.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';

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
      return _buildHomePage(context);
    }

    // Show chapter page
    return _buildChapterPage(context, widget.model.selectedChapter!);
  }

  Widget _buildHomePage(BuildContext context) {
    // Show loading state
    if (widget.model.isBusy(widget.model.NEW_IB_FETCH_HOME)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state
    if (widget.model.isError(widget.model.NEW_IB_FETCH_HOME)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: IbTheme.textColor(context).withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load home page',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.model.errorMessageFor(widget.model.NEW_IB_FETCH_HOME) ?? 'Unknown error',
                style: TextStyle(
                  fontSize: 14,
                  color: IbTheme.textColor(context).withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => widget.model.fetchHomeData(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IbTheme.getPrimaryColor(context),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Get home data
    final homeData = widget.model.homeData;
    if (homeData == null) {
      return const Center(child: Text('No home data available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Section with Icon
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: IbTheme.getPrimaryColor(context).withAlpha(26),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: IbTheme.getPrimaryColor(context).withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 56,
                    color: IbTheme.getPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  homeData.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: IbTheme.primaryHeadingColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  homeData.subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: IbTheme.textColor(context).withAlpha(204),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // Content Box with all sections
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IbTheme.textColor(context).withAlpha(13),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: homeData.content.sections.map((section) {
                return _buildHomeSection(context, section);
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Feature Cards Grid (2x2)
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  context,
                  Icons.school_rounded,
                  'Learn',
                  'Comprehensive digital logic tutorials',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFeatureCard(
                  context,
                  Icons.science_rounded,
                  'Experiment',
                  'Interactive circuit simulations',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  context,
                  Icons.quiz_rounded,
                  'Practice',
                  'Quizzes and exercises',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFeatureCard(
                  context,
                  Icons.emoji_events_rounded,
                  'Master',
                  'Track your progress',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Getting Started Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  IbTheme.getPrimaryColor(context),
                  IbTheme.getPrimaryColor(context).withAlpha(204),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Getting Started',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildGettingStartedStep(
                  context,
                  '1',
                  'Choose a Chapter',
                  'Browse chapters from the menu',
                ),
                const SizedBox(height: 16),
                _buildGettingStartedStep(
                  context,
                  '2',
                  'Learn Concepts',
                  'Read through interactive lessons',
                ),
                const SizedBox(height: 16),
                _buildGettingStartedStep(
                  context,
                  '3',
                  'Practice',
                  'Test your knowledge with quizzes',
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              homeData.metadata.copyright,
              style: TextStyle(
                fontSize: 12,
                color: IbTheme.textColor(context).withAlpha(128),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeSection(BuildContext context, NewIbHomeSection section) {
    switch (section.type) {
      case 'heading':
        if (section.level == 1) {
          // Skip H1 as it's already in the hero section
          return const SizedBox.shrink();
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

      case 'subtitle':
        // Skip subtitle as it's in the hero section
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

      case 'divider':
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: IbTheme.textColor(context).withAlpha(26),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: IbTheme.getPrimaryColor(context).withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 32,
              color: IbTheme.getPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: IbTheme.primaryHeadingColor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: IbTheme.textColor(context).withAlpha(179),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGettingStartedStep(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(204),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChapterCard(BuildContext context, NewIbChapter chapter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: InkWell(
        onTap: () {
          widget.model.selectChapter(chapter);
          widget.model.setHome(false);
          widget.onNavigate(chapter);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: IbTheme.getPrimaryColor(context).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.article_rounded,
                  size: 32,
                  color: IbTheme.getPrimaryColor(context),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: IbTheme.primaryHeadingColor(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.heading ?? chapter.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: IbTheme.textColor(context).withAlpha(179),
                      ),
                    ),
                    if (chapter.description != null && chapter.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        chapter.description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: IbTheme.textColor(context).withAlpha(153),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: IbTheme.textColor(context).withAlpha(128),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterPage(BuildContext context, NewIbChapter chapter) {
    // Load recommendations if not already loaded or loading
    if (!_loadingRecommendations && _recommendations.isEmpty) {
      // Use addPostFrameCallback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_loadingRecommendations && _recommendations.isEmpty) {
          print('NewIbContent: Calling _loadRecommendations from _buildChapterPage');
          _loadRecommendations();
        }
      });
    }

    // Show loading state
    if (widget.model.isBusy(widget.model.NEW_IB_FETCH_CHAPTER_INDEX)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state
    if (widget.model.isError(widget.model.NEW_IB_FETCH_CHAPTER_INDEX)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: IbTheme.textColor(context).withAlpha(128),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load chapter',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                widget.model.errorMessageFor(widget.model.NEW_IB_FETCH_CHAPTER_INDEX) ?? 'Unknown error',
                style: TextStyle(
                  fontSize: 14,
                  color: IbTheme.textColor(context).withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => widget.model.fetchChapterIndexData(chapter.path),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IbTheme.getPrimaryColor(context),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    // Get chapter index data
    final chapterData = widget.model.chapterIndexData;
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
            ...chapterData.children.map((child) => _buildChildTile(context, child)),
          ],

          const SizedBox(height: 32),

          // Also on Interactive Book (Recommendations)
          _buildRecommendationsSection(context),

          const SizedBox(height: 32),

          // Comments Section
          _buildCommentsSection(context),

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

  Widget _buildChildTile(BuildContext context, NewIbChapterChild child) {
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
          // TODO: Navigate to child page
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
                  child.title,
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
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    print('NewIbContent: _buildRecommendationsSection called');
    print('NewIbContent: _loadingRecommendations: $_loadingRecommendations');
    print('NewIbContent: _recommendations.length: ${_recommendations.length}');
    
    if (_loadingRecommendations) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: IbTheme.getPrimaryColor(context),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Also on Interactive Book',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: IbTheme.primaryHeadingColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_stories_rounded,
              color: IbTheme.getPrimaryColor(context),
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Also on Interactive Book',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_recommendations.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'No recommendations available',
                style: TextStyle(
                  fontSize: 14,
                  color: IbTheme.textColor(context).withAlpha(128),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendations.length > 5 ? 5 : _recommendations.length,
              itemBuilder: (context, index) {
                final rec = _recommendations[index];
                return _buildRecommendationCard(context, rec);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    IbRecommendation recommendation,
  ) {
    // Format date
    String formattedDate = '';
    if (recommendation.createdAt != null) {
      try {
        final date = DateTime.parse(recommendation.createdAt!);
        formattedDate =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = '';
      }
    }
    return Container(
      width: 280,
      height: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
        color: IbTheme.getPrimaryColor(context).withAlpha(51),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (recommendation.image != null)
              Image.network(
                recommendation.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: IbTheme.getPrimaryColor(context).withAlpha(51),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: IbTheme.getPrimaryColor(context).withAlpha(51),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Content
            InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (formattedDate.isNotEmpty) ...[
                          const Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                        if (formattedDate.isNotEmpty && recommendation.posts != null)
                          const SizedBox(width: 12),
                        if (recommendation.posts != null) ...[
                          const Icon(
                            Icons.comment,
                            size: 12,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${recommendation.posts} comment${recommendation.posts! > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.comment_rounded,
              color: IbTheme.getPrimaryColor(context),
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Comments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCommentInput(context),
        const SizedBox(height: 24),
        _buildCommentsList(context),
      ],
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your thoughts or ask a question...',
              hintStyle: TextStyle(
                color: IbTheme.textColor(context).withAlpha(128),
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(color: IbTheme.textColor(context), fontSize: 16),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send_rounded, size: 18),
              label: const Text('Post Comment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: IbTheme.getPrimaryColor(context),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList(BuildContext context) {
    final comments = [
      {
        'author': 'Santam',
        'time': '2 hours ago',
        'text': 'Great explanation! This really helped me understand binary representation.',
        'likes': 12,
      },
      {
        'author': 'Roy',
        'time': '5 hours ago',
        'text': 'Can someone explain the difference between signed and unsigned numbers?',
        'likes': 5,
      },
      {
        'author': 'Choudhury',
        'time': '1 day ago',
        'text': 'The examples are very clear. Thanks for this resource!',
        'likes': 8,
      },
    ];

    return Column(
      children: comments
          .map(
            (comment) => _buildCommentCard(
              context,
              comment['author'] as String,
              comment['time'] as String,
              comment['text'] as String,
              comment['likes'] as int,
            ),
          )
          .toList(),
    );
  }

  Widget _buildCommentCard(
    BuildContext context,
    String author,
    String time,
    String text,
    int likes,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IbTheme.textColor(context).withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: IbTheme.getPrimaryColor(context).withAlpha(51),
                child: Text(
                  author[0].toUpperCase(),
                  style: TextStyle(
                    color: IbTheme.getPrimaryColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IbTheme.primaryHeadingColor(context),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: IbTheme.textColor(context).withAlpha(128),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: IbTheme.textColor(context).withAlpha(204),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up_outlined,
                      size: 18,
                      color: IbTheme.textColor(context).withAlpha(179),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$likes',
                      style: TextStyle(
                        fontSize: 14,
                        color: IbTheme.textColor(context).withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(
                      Icons.reply_rounded,
                      size: 18,
                      color: IbTheme.textColor(context).withAlpha(179),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 14,
                        color: IbTheme.textColor(context).withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
