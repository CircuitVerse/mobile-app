import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/progress.dart';

/// Overall completion across the whole book.
class OverallProgressCard extends StatelessWidget {
  const OverallProgressCard({
    super.key,
    required this.chapters,
    required this.progress,
    required this.onResetProgress,
  });

  final List<Chapter> chapters;
  final BookProgress progress;
  final VoidCallback onResetProgress;

  @override
  Widget build(BuildContext context) {
    final completed = progress.completedTopics(chapters);
    final total = progress.totalTopics(chapters);
    final value = progress.overallProgress(chapters);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ProgressRing(value: value),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Overall Progress',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (completed > 0)
                      InkWell(
                        onTap: onResetProgress,
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.restart_alt,
                            size: 18,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$completed / $total topics completed',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 7,
                    backgroundColor: Color(0xFFDFE3E0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF12A150),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 66,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 7,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFDFE3E0)),
            ),
          ),
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF12A150),
              ),
            ),
          ),
          Text(
            '${(value * 100).round()}%',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
