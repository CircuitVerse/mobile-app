import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/progress.dart';

/// Chapters that are less than half read are flagged amber so a stalled
/// chapter stands out from the ones that are nearly done.
Color _progressColor(double value) {
  if (value <= 0) return const Color(0xFFDFE3E0);
  return value < 0.5 ? const Color(0xFFE8842A) : const Color(0xFF12A150);
}

/// One chapter in the drawer: a header showing its completion, and — when
/// expanded — a timeline of its sub-chapters.
class NavbarChapters extends StatelessWidget {
  const NavbarChapters({
    super.key,
    required this.chapter,
    required this.progress,
    required this.isExpanded,
    required this.onToggle,
    required this.onOpenChapter,
    required this.onOpenSubChapter,
  });

  final Chapter chapter;
  final BookProgress progress;
  final bool isExpanded;
  final VoidCallback onToggle;

  /// Opens the chapter intro page (`sub_chapter_id == 0`).
  final VoidCallback onOpenChapter;
  final void Function(int subChapterId) onOpenSubChapter;

  @override
  Widget build(BuildContext context) {
    final value = progress.chapterProgress(chapter);
    final isCurrent = progress.isCurrentChapter(chapter.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            isCurrent
                ? Border.all(color: Color(0xFF12A150).withValues(alpha: 0.45))
                : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _header(context, value),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child:
                isExpanded
                    ? Column(children: _subChapterRows(context))
                    : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, double value) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Row(
          children: [
            // Tapping the number opens the chapter's intro page, while the
            // rest of the header just expands the list.
            InkWell(
              onTap: onOpenChapter,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFE7F6EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${chapter.id}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12A150),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    chapter.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 5,
                      backgroundColor: Color(0xFFDFE3E0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _progressColor(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 38,
              child: Text(
                '${(value * 100).round()}%',
                textAlign: TextAlign.end,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: value <= 0 ? Color(0xFF6B7280) : _progressColor(value),
                ),
              ),
            ),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 180),
              child: Icon(
                Icons.expand_more,
                size: 22,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _subChapterRows(BuildContext context) {
    final rows = <Widget>[Divider(height: 1, color: Color(0xFFDFE3E0))];

    for (var i = 0; i < chapter.subChapters.length; i++) {
      final sub = chapter.subChapters[i];
      rows.add(
        _SubChapterRow(
          label: '${chapter.id}.${sub.id}',
          name: sub.name,
          status: progress.statusOf(chapter.id, sub.id),
          isFirst: i == 0,
          isLast: i == chapter.subChapters.length - 1,
          onTap: () => onOpenSubChapter(sub.id),
        ),
      );
    }

    return rows;
  }
}

class _SubChapterRow extends StatelessWidget {
  const _SubChapterRow({
    required this.label,
    required this.name,
    required this.status,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final String label;
  final String name;
  final TopicStatus status;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCurrent = status == TopicStatus.inProgress;

    return InkWell(
      onTap: onTap,
      child: Container(
        color:
            isCurrent
                ? Color(0xFF12A150).withValues(alpha: 0.08)
                : Colors.transparent,
        padding: const EdgeInsets.only(right: 12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _TimelineNode(status: status, isFirst: isFirst, isLast: isLast),
              const SizedBox(width: 4),
              SizedBox(
                width: 32,
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Color(0xFF12A150),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(status: status),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dot-and-rail marker on the left of each sub-chapter row.
class _TimelineNode extends StatelessWidget {
  const _TimelineNode({
    required this.status,
    required this.isFirst,
    required this.isLast,
  });

  final TopicStatus status;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final railColor = Color(0xFFDFE3E0);

    return SizedBox(
      width: 34,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : railColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : railColor,
                  ),
                ),
              ],
            ),
          ),
          _dot(context),
        ],
      ),
    );
  }

  Widget _dot(BuildContext context) {
    switch (status) {
      case TopicStatus.completed:
        return Container(
          width: 13,
          height: 13,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF12A150),
          ),
        );
      case TopicStatus.inProgress:
        return Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Color(0xFF12A150), width: 2.5),
          ),
        );
      case TopicStatus.notStarted:
        return Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Color(0xFF6B7280).withValues(alpha: 0.55),
              width: 1.5,
            ),
          ),
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TopicStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TopicStatus.completed:
        return const Icon(
          Icons.check_circle,
          size: 19,
          color: Color(0xFF12A150),
        );
      case TopicStatus.inProgress:
        return Text(
          'Reading',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Color(0xFF12A150),
            fontWeight: FontWeight.w600,
          ),
        );
      case TopicStatus.notStarted:
        return const SizedBox(width: 19);
    }
  }
}
