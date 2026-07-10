import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/navbar.dart';
import 'package:mobile_app/features/interactive-book/ui/home/home.dart';
import 'package:mobile_app/features/interactive-book/ui/renderer.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/model.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/service.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool isLoading = true;
  bool isHomePage = true;
  bool showBackArrow = false;
  bool showForwardArrow = true;
  int chapterNumber = 1;
  int subChapterNumber = 0;

  late Future<InteractiveBookNavbarModel> navbarData;

  @override
  void initState() {
    super.initState();
    navbarData = BookService().getChapters();
  }

  void changeHomePage(bool value) {
    setState(() {
      isHomePage = value;
      if(value) {
        chapterNumber = -1;
        subChapterNumber = -1;
      }
    });
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
    if (newChapter == data.chapters.length && newSubChapter == data.chapters[newChapter - 1].subChapters.length - 2) {
      newForwardArrow = true;
    }
    setState(() {
      chapterNumber = newChapter;
      subChapterNumber = newSubChapter;
      showBackArrow = newBackArrow;
      showForwardArrow = newForwardArrow;
    });
  }

  void getStarted() {
    setState(() {
      isHomePage = false;
      chapterNumber = 1;
      subChapterNumber = 0;
    });
  }

  void navigateToChapter(int chapter, int subChapter) {
    setState(() {
      isHomePage = false;
      chapterNumber = chapter;
      subChapterNumber = subChapter;
    });
  }

  Widget getCurrentPage() {
    if (isHomePage) {
      return InteractiveBookHome(getStarted: getStarted);
    } else {
      return Renderer(
        chapterNumber: chapterNumber,
        subChapterNumber: subChapterNumber,
        incrementChapter: incrementChapter,
        decrementChapter: decrementChapter,
        showBackArrow: showBackArrow,
        showForwardArrow: showForwardArrow,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Book')),
      drawer: Navbar(
        isHomePage: isHomePage,
        chapterNumber: chapterNumber,
        subChapterNumber: subChapterNumber,
        changeHomePage: changeHomePage,
        navigateToChapter: navigateToChapter,
        navbarData: navbarData,
      ),
      body: getCurrentPage(),
    );
  }
}
