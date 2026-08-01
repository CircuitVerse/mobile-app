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
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool isLoading = true;
  IbPage currentPage = IbPage.home;
  bool showBackArrow = false;
  bool showForwardArrow = true;
  int chapterNumber = 1;
  int subChapterNumber = 0;

  late Future<InteractiveBookNavbarModel> navbarData;

  final BookProgress progress = BookProgress();
  final OfflineLibrary offline = OfflineLibrary();

  @override
  void initState() {
    super.initState();
    navbarData = BookService().getChapters();
    progress.load();
    offline.refresh();
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
    int newChapter = chapterNumber;
    int newSubChapter = subChapterNumber;
    bool newBackArrow = true;
    bool newForwardArrow = true;
    if (data.chapters[chapterNumber - 1].subChapters.length >
        subChapterNumber) {
      newChapter = chapterNumber;
      newSubChapter = subChapterNumber + 1;
    } else if (data.chapters.length > chapterNumber) {
      newChapter = chapterNumber + 1;
      newSubChapter = 0;
    } else {
      newForwardArrow = false;
    }
    if (newChapter == 1 && newSubChapter == 0) {
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
    int newChapter = chapterNumber;
    int newSubChapter = subChapterNumber;
    bool newBackArrow = true;
    bool newForwardArrow = true;
    if (subChapterNumber > 0) {
      newChapter = chapterNumber;
      newSubChapter = subChapterNumber - 1;
    } else if (chapterNumber > 1) {
      newChapter = chapterNumber - 1;
      newSubChapter = data.chapters[newChapter - 1].subChapters.length - 1;
    } else {
      newBackArrow = false;
    }
    if (newChapter == data.chapters.length &&
        newSubChapter == data.chapters[newChapter - 1].subChapters.length - 2) {
      newForwardArrow = true;
    }
    setState(() {
      chapterNumber = newChapter;
      subChapterNumber = newSubChapter;
      showBackArrow = newBackArrow;
      showForwardArrow = newForwardArrow;
    });
    await progress.visit(newChapter, newSubChapter);
  }

  /// Leaves the book. `Root` is pushed onto the app's stack with `Get.to`
  /// from the main drawer, so popping it returns the user where they came from.
  void exitBook() {
    Get.back();
  }

  void getStarted() {
    setState(() {
      currentPage = IbPage.chapter;
      chapterNumber = 1;
      subChapterNumber = 0;
    });
    progress.visit(1, 0);
  }

  Future<void> navigateToChapter(int chapter, int subChapter) async {
    final data = await navbarData;
    setState(() {
      currentPage = IbPage.chapter;
      chapterNumber = chapter;
      subChapterNumber = subChapter;
      if (!(chapter == 1 && subChapter == 0)) {
        showBackArrow = true;
      } else {
        showBackArrow = false;
      }
      if (chapter == data.chapters.length &&
          subChapter == data.chapters[chapter - 1].subChapters.length - 1) {
        showForwardArrow = false;
      } else {
        showForwardArrow = true;
      }
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
    } else {
      return Renderer(
        page: currentPage,
        chapterNumber: chapterNumber,
        subChapterNumber: subChapterNumber,
        incrementChapter: incrementChapter,
        decrementChapter: decrementChapter,
        showBackArrow: showBackArrow,
        showForwardArrow: showForwardArrow,
        navigateToChapter: navigateToChapter,
      );
    }
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
