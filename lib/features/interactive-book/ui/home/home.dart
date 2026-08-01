import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/progress.dart';
import 'package:mobile_app/features/interactive-book/ui/home/features_grid.dart';
import 'package:mobile_app/features/interactive-book/ui/home/getting_started.dart';
import 'package:mobile_app/features/interactive-book/ui/home/hero.dart';

class InteractiveBookHome extends StatelessWidget {
  final void Function() getStarted;
  final void Function(int chapter, int subChapter) navigateToChapter;
  final Future<InteractiveBookNavbarModel> navbarData;
  final BookProgress progress;

  const InteractiveBookHome({
    super.key,
    required this.getStarted,
    required this.navigateToChapter,
    required this.navbarData,
    required this.progress,
  });

  static const List<(String, String)> _about = [
    (
      'Overview',
      'Computer Logical Organization is the abstraction below the operating '
          'system and above the digital logic level. This book covers computer '
          'overview through advanced topics, helping you analyze and implement '
          'combinational and sequential circuits for real applications.',
    ),
    (
      'Audience',
      'Students interested in digital circuits and computer logical '
          'organization. Topics assume basic familiarity with digital '
          'electronics and binary logic.',
    ),
    (
      'Prerequisites',
      'A basic understanding of computers and initial digital electronics '
          'concepts is helpful before starting this book.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF7F8F7),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          FutureBuilder<InteractiveBookNavbarModel>(
            future: navbarData,
            builder: (context, snapshot) {
              final chapters = snapshot.data?.chapters ?? const <Chapter>[];

              return ListenableBuilder(
                listenable: progress,
                builder: (context, _) {
                  return HomeHero(
                    chapters: chapters,
                    progress: progress,
                    onStart: getStarted,
                    onOpen: navigateToChapter,
                  );
                },
              );
            },
          ),
          const _SectionTitle('Why this book'),
          const FeaturesGrid(),
          const _SectionTitle('About this book'),
          _aboutCard(context),
          const _SectionTitle('How to use it'),
          const GettingStarted(),
        ],
      ),
    );
  }

  Widget _aboutCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDFE3E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _about.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            Text(
              _about[i].$1,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Color(0xFF12A150),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              _about[i].$2,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 26, 0, 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: Color(0xFF12A150),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 9),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
