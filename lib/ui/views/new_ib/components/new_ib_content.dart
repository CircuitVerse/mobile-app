import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/models/ib/new_ib_home_data.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';

class NewIbContent extends StatelessWidget {
  final NewIbLandingViewModel model;
  final Function(NewIbChapter?) onNavigate;

  const NewIbContent({
    super.key,
    required this.model,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Show home page if no chapter selected or home is selected
    if (model.isHome || model.selectedChapter == null) {
      return _buildHomePage(context);
    }

    // Show chapter page
    return _buildChapterPage(context, model.selectedChapter!);
  }

  Widget _buildHomePage(BuildContext context) {
    // Show loading state
    if (model.isBusy(model.NEW_IB_FETCH_HOME)) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state
    if (model.isError(model.NEW_IB_FETCH_HOME)) {
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
                model.errorMessageFor(model.NEW_IB_FETCH_HOME) ?? 'Unknown error',
                style: TextStyle(
                  fontSize: 14,
                  color: IbTheme.textColor(context).withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => model.fetchHomeData(),
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
    final homeData = model.homeData;
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
          model.selectChapter(chapter);
          model.setHome(false);
          onNavigate(chapter);
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction_rounded,
            size: 80,
            color: IbTheme.getPrimaryColor(context).withAlpha(128),
          ),
          const SizedBox(height: 24),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: IbTheme.primaryHeadingColor(context),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Chapter content will be loaded here',
            style: TextStyle(
              fontSize: 16,
              color: IbTheme.textColor(context).withAlpha(179),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'API: ${chapter.apiUrl}',
              style: TextStyle(
                fontSize: 12,
                color: IbTheme.textColor(context).withAlpha(128),
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
