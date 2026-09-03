import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/navbar.dart';
import 'package:mobile_app/features/interactive-book/ui/home/home.dart';
import 'package:mobile_app/features/interactive-book/ui/renderer.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/models/page.dart';
import 'package:mobile_app/features/interactive-book/services/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/offline.dart';
import 'package:mobile_app/features/interactive-book/services/progress.dart';

class Root extends StatefulWidget {
  static const String id = 'interactive_book_view';

  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  IbPage currentPage = IbPage.home;
  bool showBackArrow = false;
  bool showForwardArrow = true;
  int chapterNumber = 1;
  int subChapterNumber = 0;

  late Future<InteractiveBookNavbarModel> navbarData;

  /// Resolved copy of [navbarData]. The content API addresses chapter pages by
  /// slug, and the navbar is the only thing that knows a chapter's slug.
  InteractiveBookNavbarModel? _navbar;
  Object? _navbarError;

  final BookProgress progress = BookProgress();
  final OfflineLibrary offline = OfflineLibrary();

  @override
  void initState() {
    super.initState();
    navbarData = NavbarService().getChapters();
    _resolveNavbar();
    progress.load();
    offline.refresh();
  }

  Future<void> _resolveNavbar() async {
    try {
      final data = await navbarData;
      if (mounted) setState(() => _navbar = data);
    } catch (error) {
      if (mounted) setState(() => _navbarError = error);
    }
  }

  @override
  void dispose() {
    progress.dispose();
    offline.dispose();
    super.dispose();
  }

  /// Switches to Home, About or Guidelines. Chapter navigation goes through
  /// [navigateToChapter] instead, since it carries a position.
  void openPage(IbPage page) {
    setState(() {
      currentPage = page;
      chapterNumber = -1;
      subChapterNumber = -1;
      // None of these pages sit in the reading sequence.
      showBackArrow = false;
      showForwardArrow = false;
    });
    progress.clearCurrent();
  }

  void changeChapter(int chapter, int subChapter) {
    setState(() {
      chapterNumber = chapter;
      subChapterNumber = subChapter;
    });
  }

  Future<void> incrementChapter() async {
    final data = await navbarData;
    final index = data.indexOfChapter(chapterNumber);
    if (index < 0) return;

    int newChapter = chapterNumber;
    int newSubChapter = subChapterNumber;
    bool newBackArrow = true;
    bool newForwardArrow = true;
    if (data.chapters[index].subChapters.length > subChapterNumber) {
      newSubChapter = subChapterNumber + 1;
    } else if (index + 1 < data.chapters.length) {
      newChapter = data.chapters[index + 1].id;
      newSubChapter = 0;
    } else {
      newForwardArrow = false;
    }
    if (newChapter == data.chapters.first.id && newSubChapter == 0) {
      newBackArrow = false;
    }
    setState(() {
      chapterNumber = newChapter;
      subChapterNumber = newSubChapter;
      showBackArrow = newBackArrow;
      showForwardArrow = newForwardArrow;
    });
    await progress.visit(newChapter, newSubChapter);
  }

  Future<void> decrementChapter() async {
    final data = await navbarData;
    final index = data.indexOfChapter(chapterNumber);
    if (index < 0) return;

    int newChapter = chapterNumber;
    int newSubChapter = subChapterNumber;
    bool newBackArrow = true;
    if (subChapterNumber > 0) {
      newSubChapter = subChapterNumber - 1;
    } else if (index > 0) {
      final previous = data.chapters[index - 1];
      newChapter = previous.id;
      newSubChapter = previous.subChapters.length;
    } else {
      newBackArrow = false;
    }
    setState(() {
      chapterNumber = newChapter;
      subChapterNumber = newSubChapter;
      showBackArrow = newBackArrow;
      // Stepping back always leaves a page ahead to return to.
      showForwardArrow = true;
    });
    await progress.visit(newChapter, newSubChapter);
  }

  /// Leaves the book. `Root` is pushed onto the app's stack with `Get.to`
  /// from the main drawer, so popping it returns the user where they came from.
  void exitBook() {
    Get.back();
  }

  Future<void> getStarted() async {
    setState(() {
      currentPage = IbPage.chapter;
      chapterNumber = 1;
      subChapterNumber = 0;
      showBackArrow = false;
      showForwardArrow = true;
    });
    await progress.visit(1, 0);
  }

  Future<void> navigateToChapter(int chapter, int subChapter) async {
    final data = await navbarData;
    final index = data.indexOfChapter(chapter);

    // The last page of the last chapter is the end of the book; the intro of
    // the first chapter is the start.
    final isLastChapter = index == data.chapters.length - 1;
    final isLastPage =
        index >= 0 && subChapter == data.chapters[index].subChapters.length;
    final isFirstPage =
        data.chapters.isNotEmpty &&
        chapter == data.chapters.first.id &&
        subChapter == 0;

    setState(() {
      currentPage = IbPage.chapter;
      chapterNumber = chapter;
      subChapterNumber = subChapter;
      showBackArrow = !isFirstPage;
      showForwardArrow = !(isLastChapter && isLastPage);
    });
    await progress.visit(chapter, subChapter);
  }

  Widget getCurrentPage() {
    if (currentPage == IbPage.home) {
      return InteractiveBookHome(
        getStarted: getStarted,
        navigateToChapter: navigateToChapter,
        navbarData: navbarData,
        progress: progress,
      );
    }

    // Chapter pages cannot be fetched until the navbar has supplied the
    // chapter's slug. About and Guidelines have endpoints of their own.
    var chapterPath = '';
    if (currentPage == IbPage.chapter) {
      if (_navbar == null) {
        if (_navbarError != null) {
          return Center(child: Text(_navbarError.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      }

      final chapter = _navbar!.chapterById(chapterNumber);
      if (chapter == null) {
        // Better to say so than to request a page under an empty slug.
        return Center(
          child: Text('Chapter $chapterNumber is not part of this book.'),
        );
      }
      chapterPath = chapter.path;
    }

    return Renderer(
      page: currentPage,
      chapterNumber: chapterNumber,
      subChapterNumber: subChapterNumber,
      chapterPath: chapterPath,
      incrementChapter: incrementChapter,
      decrementChapter: decrementChapter,
      showBackArrow: showBackArrow,
      showForwardArrow: showForwardArrow,
      navigateToChapter: navigateToChapter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Book')),
      drawer: Navbar(
        currentPage: currentPage,
        chapterNumber: chapterNumber,
        subChapterNumber: subChapterNumber,
        openPage: openPage,
        navigateToChapter: navigateToChapter,
        exitBook: exitBook,
        navbarData: navbarData,
        progress: progress,
        offline: offline,
      ),
      body: getCurrentPage(),
    );
  }
}
