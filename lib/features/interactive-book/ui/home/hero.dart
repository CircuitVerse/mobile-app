import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/progress.dart';

/// Banner at the top of the book's home page.
///
/// Doubles as the primary call to action: once the reader has opened anything
/// it offers to resume at the first unread topic instead of starting over.
class HomeHero extends StatelessWidget {
  const HomeHero({
    super.key,
    required this.chapters,
    required this.progress,
    required this.onStart,
    required this.onOpen,
  });

  final List<Chapter> chapters;
  final BookProgress progress;
  final VoidCallback onStart;
  final void Function(int chapter, int subChapter) onOpen;

  @override
  Widget build(BuildContext context) {
    final total = progress.totalTopics(chapters);
    final completed = progress.completedTopics(chapters);
    final value = progress.overallProgress(chapters);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0A5C39), Color(0xFF11804F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF0A5C39).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(top: 14, right: 14, child: _DotGrid()),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.45),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Interactive Book',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Learn. Practice. Master.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _Stat(
                      value: chapters.isEmpty ? '—' : '${chapters.length}',
                      label: 'Chapters',
                    ),
                    _Stat(
                      value: chapters.isEmpty ? '—' : '$total',
                      label: 'Topics',
                    ),
                    _Stat(
                      value:
                          chapters.isEmpty ? '—' : '${(value * 100).round()}%',
                      label: 'Complete',
                    ),
                  ],
                ),
                if (completed > 0) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      color: Colors.white,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                _callToAction(context, completed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _callToAction(BuildContext context, int completed) {
    final next = progress.nextUnread(chapters);

    final String label;
    final VoidCallback action;

    if (next == null && chapters.isNotEmpty) {
      label = 'Read again from the start';
      action = () => onOpen(chapters.first.id, 0);
    } else if (completed == 0 || next == null) {
      label = 'Start reading';
      action = onStart;
    } else {
      label = 'Continue · ${_titleOf(next.chapter, next.subChapter)}';
      action = () => onOpen(next.chapter, next.subChapter);
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: action,
        icon: const Icon(Icons.play_arrow_rounded, size: 20),
        label: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0A5C39),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  /// `1.3 Number Bases` for the resume button.
  String _titleOf(int chapterId, int subChapterId) {
    for (final chapter in chapters) {
      if (chapter.id != chapterId) continue;
      for (final sub in chapter.subChapters) {
        if (sub.id == subChapterId) {
          return '${chapter.id}.${sub.id} ${sub.name}';
        }
      }
    }
    return 'next topic';
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

/// Decorative dot pattern in the banner's top-right corner.
class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (_) => Row(
          children: List.generate(
            6,
            (_) => Container(
              width: 3,
              height: 3,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
