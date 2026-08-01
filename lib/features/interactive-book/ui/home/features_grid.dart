import 'package:flutter/material.dart';

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.15,
      children: const [
        FeatureCard(
          icon: Icons.school_outlined,
          title: "Learn",
          subtitle: "Comprehensive digital logic tutorials",
        ),
        FeatureCard(
          icon: Icons.science_outlined,
          title: "Experiment",
          subtitle: "Interactive circuit simulations",
        ),
        FeatureCard(
          icon: Icons.quiz_outlined,
          title: "Practice",
          subtitle: "Quizzes and exercises",
        ),
        FeatureCard(
          icon: Icons.emoji_events_outlined,
          title: "Master",
          subtitle: "Track your progress",
        ),
      ],
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDFE3E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFE7F6EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: Color(0xFF12A150)),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
