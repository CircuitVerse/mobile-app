import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/models/page.dart';
import 'package:mobile_app/features/interactive-book/services/offline.dart';
import 'package:mobile_app/features/interactive-book/services/progress.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/chapters.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/header.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/nav_tile.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/offline_card.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/progress_card.dart';

class Navbar extends StatefulWidget {
  final IbPage currentPage;
  final int chapterNumber;
  final int subChapterNumber;

  /// Opens Home, About or Guidelines — the pages with no reading position.
  final void Function(IbPage) openPage;
  final void Function(int, int) navigateToChapter;

  /// Leaves the Interactive Book entirely and returns to the app.
  final VoidCallback exitBook;
  final Future<InteractiveBookNavbarModel> navbarData;
  final BookProgress progress;
  final OfflineLibrary offline;

  const Navbar({
    super.key,
    required this.currentPage,
    required this.chapterNumber,
    required this.subChapterNumber,
    required this.openPage,
    required this.navigateToChapter,
    required this.exitBook,
    required this.navbarData,
    required this.progress,
    required this.offline,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  /// Only one chapter stays open at a time, matching the accordion in the
  /// design. `null` means everything is collapsed.
  int? _expandedChapterId;

  bool get _onChapter => widget.currentPage == IbPage.chapter;

  @override
  void initState() {
    super.initState();
    _expandedChapterId = _onChapter ? widget.chapterNumber : null;
  }

  @override
  void didUpdateWidget(covariant Navbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Follow the reader when they move between chapters from the page itself.
    if (oldWidget.chapterNumber != widget.chapterNumber && _onChapter) {
      _expandedChapterId = widget.chapterNumber;
    }
  }

  void _openPage(IbPage page) {
    widget.openPage(page);
    Navigator.pop(context);
  }

  void _openChapter(int chapter, int subChapter) {
    widget.navigateToChapter(chapter, subChapter);
    Navigator.pop(context);
  }

  void _exitBook() {
    // Close the drawer first, then pop the book off the app's navigation stack.
    Navigator.pop(context);
    widget.exitBook();
  }

  Future<void> _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset progress?'),
            content: const Text(
              'Every topic will be marked as unread. Downloaded content is '
              'not affected.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Reset'),
              ),
            ],
          ),
    );

    if (confirmed ?? false) {
      await widget.progress.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.86;

    return Drawer(
      width: width.clamp(280.0, 400.0),
      backgroundColor: Color(0xFFF7F8F7),
      child: Column(
        children: [
          const InteractiveBookDrawerHeader(),
          Expanded(
            child: FutureBuilder<InteractiveBookNavbarModel>(
              future: widget.navbarData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return _ErrorState(
                    message:
                        snapshot.error?.toString() ?? 'Failed to load chapters',
                    onGoHome: () => _openPage(IbPage.home),
                  );
                }

                return _buildBody(context, snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, InteractiveBookNavbarModel data) {
    final chapters = data.chapters;

    return ListenableBuilder(
      // Both stores drive this list, so rebuild on either.
      listenable: Listenable.merge([widget.progress, widget.offline]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 24),
          children: [
            OverallProgressCard(
              chapters: chapters,
              progress: widget.progress,
              onResetProgress: _confirmReset,
            ),
            const SizedBox(height: 10),
            _EncouragementCard(
              chapters: chapters,
              progress: widget.progress,
              onContinue: _openChapter,
            ),
            const SizedBox(height: 10),
            OfflineModeCard(library: widget.offline, navbarData: data),
            const SizedBox(height: 10),
            NavbarTile(
              icon: Icons.home_outlined,
              label: 'Home',
              isSelected: widget.currentPage == IbPage.home,
              onTap: () => _openPage(IbPage.home),
            ),
            const _SectionLabel('TOPICS'),
            for (final chapter in chapters)
              NavbarChapters(
                chapter: chapter,
                progress: widget.progress,
                isExpanded: _expandedChapterId == chapter.id,
                onToggle: () {
                  setState(() {
                    _expandedChapterId =
                        _expandedChapterId == chapter.id ? null : chapter.id;
                  });
                },
                onOpenChapter: () => _openChapter(chapter.id, 0),
                onOpenSubChapter: (subId) => _openChapter(chapter.id, subId),
              ),
            const SizedBox(height: 6),
            NavbarTile(
              icon: Icons.info_outline,
              label: 'About',
              isSelected: widget.currentPage == IbPage.about,
              onTap: () => _openPage(IbPage.about),
            ),
            const SizedBox(height: 8),
            NavbarTile(
              icon: Icons.menu_book_outlined,
              label: 'Guidelines',
              isSelected: widget.currentPage == IbPage.guidelines,
              onTap: () => _openPage(IbPage.guidelines),
            ),
            const SizedBox(height: 18),
            Divider(height: 1, color: Color(0xFFDFE3E0)),
            const SizedBox(height: 12),
            // Neutral tint so leaving the book reads differently from the
            // green rows above, which all stay inside it.
            NavbarTile(
              icon: Icons.exit_to_app,
              label: 'Exit Interactive Book',
              tint: const Color(0xFF6B7280),
              tintSurface: const Color(0xFFEEF0EF),
              onTap: _exitBook,
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 0, 10),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Divider(height: 1, color: Color(0xFFDFE3E0))),
        ],
      ),
    );
  }
}

/// Footer that resumes reading at the first unopened topic.
class _EncouragementCard extends StatelessWidget {
  const _EncouragementCard({
    required this.chapters,
    required this.progress,
    required this.onContinue,
  });

  final List<Chapter> chapters;
  final BookProgress progress;
  final void Function(int chapter, int subChapter) onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final next = progress.nextUnread(chapters);
    final completed = progress.completedTopics(chapters);

    final String title;
    final String subtitle;
    if (next == null) {
      title = 'Book complete! 🏆';
      subtitle = 'You have read every topic.';
    } else if (completed == 0) {
      title = 'Ready to start? 🚀';
      subtitle = 'Jump into the first topic.';
    } else {
      title = 'Keep going! 🎉';
      subtitle = 'Pick up where you left off.';
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap:
            next == null
                ? null
                : () => onContinue(next.chapter, next.subChapter),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                color: Color(0xFF12A150),
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              if (next != null)
                Icon(Icons.chevron_right, size: 20, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onGoHome});

  final String message;
  final VoidCallback onGoHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 40, color: Color(0xFF6B7280)),
          const SizedBox(height: 12),
          Text(
            'Could not load the chapter list',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onGoHome,
            icon: const Icon(Icons.home_outlined),
            label: const Text('Go to Home'),
          ),
        ],
      ),
    );
  }
}
