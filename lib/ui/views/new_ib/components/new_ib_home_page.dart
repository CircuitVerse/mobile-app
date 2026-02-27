import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_markdown_parser.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';

class NewIbHomePage extends StatelessWidget {
  final IbChapter chapter;

  const NewIbHomePage({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return BaseView<IbPageViewModel>(
      onModelReady: (model) {
        model.fetchPageData(id: chapter.id);
      },
      builder: (context, model, child) {
        if (!model.isSuccess(model.IB_FETCH_PAGE_DATA)) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (model.pageData == null) {
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
                  'Failed to load content',
                  style: TextStyle(
                    fontSize: 18,
                    color: IbTheme.textColor(context).withAlpha(179),
                  ),
                ),
              ],
            ),
          );
        }

        return _buildContent(context, model.pageData!);
      },
    );
  }

  Widget _buildContent(BuildContext context, IbPageData pageData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  IbTheme.getPrimaryColor(context).withAlpha(26),
                  IbTheme.getPrimaryColor(context).withAlpha(13),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: IbTheme.getPrimaryColor(context).withAlpha(26),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: IbTheme.getPrimaryColor(context).withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 64,
                    color: IbTheme.getPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'CircuitVerse Interactive Book',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: IbTheme.primaryHeadingColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Learn Digital Logic Design',
                  style: TextStyle(
                    fontSize: 16,
                    color: IbTheme.textColor(context).withAlpha(204),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Content from API
          if (pageData.content != null && pageData.content!.isNotEmpty)
            ...pageData.content!.map((content) {
              if (content is IbMd) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildMarkdownContent(context, content.content),
                );
              }
              return const SizedBox.shrink();
            }),

          // Features Grid
          const SizedBox(height: 16),
          _buildFeaturesGrid(context),

          const SizedBox(height: 32),

          // Getting Started Section
          _buildGettingStartedSection(context),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              '© CircuitVerse Interactive Book',
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

  Widget _buildMarkdownContent(BuildContext context, String content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IbTheme.textColor(context).withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: NewIbMarkdownParser.parse(context, content),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final features = [
      {
        'icon': Icons.school_rounded,
        'title': 'Learn',
        'description': 'Comprehensive digital logic tutorials',
      },
      {
        'icon': Icons.science_rounded,
        'title': 'Experiment',
        'description': 'Interactive circuit simulations',
      },
      {
        'icon': Icons.quiz_rounded,
        'title': 'Practice',
        'description': 'Quizzes and exercises',
      },
      {
        'icon': Icons.emoji_events_rounded,
        'title': 'Master',
        'description': 'Track your progress',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                feature['icon'] as IconData,
                size: 40,
                color: IbTheme.getPrimaryColor(context),
              ),
              const SizedBox(height: 12),
              Text(
                feature['title'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IbTheme.primaryHeadingColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                feature['description'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: IbTheme.textColor(context).withAlpha(179),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGettingStartedSection(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(16),
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
              const Expanded(
                child: Text(
                  'Getting Started',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStep(
            context,
            '1',
            'Choose a Chapter',
            'Browse chapters from the menu',
          ),
          const SizedBox(height: 12),
          _buildStep(
            context,
            '2',
            'Learn Concepts',
            'Read through interactive lessons',
          ),
          const SizedBox(height: 12),
          _buildStep(
            context,
            '3',
            'Practice',
            'Test your knowledge with quizzes',
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 16,
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
                  color: Colors.white.withAlpha(230),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
