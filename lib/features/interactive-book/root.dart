import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/navbar.dart';
import 'package:mobile_app/features/interactive-book/ui/home/home.dart';
import 'package:mobile_app/features/interactive-book/ui/renderer.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  bool isLoading = true;
  bool isHomePage = true;
  int chapterNumber = 1;
  int subChapterNumber = 0;

  void changeHomePage(bool value) {
    setState(() {
      isHomePage = value;
    });
  }

  void changeChapter(int chapter, int subChapter) {
    setState(() {
      chapterNumber = chapter;
      subChapterNumber = subChapter;
    });
  }

  void incrementChapter() {
    setState(() {
      subChapterNumber = subChapterNumber + 1;
    });
  }

  void decrementChapter() {
    setState(() {
      subChapterNumber = subChapterNumber - 1;
    });
  }

  Widget getCurrentPage() {
    if (isHomePage) {
      return InteractiveBookHome(
        isHomePage: true,
        changeHomePage: changeHomePage,
      );
    } else {
      return Renderer(
        chapterNumber: chapterNumber,
        subChapterNumber: subChapterNumber,
        incrementChapter: incrementChapter,
        decrementChapter: decrementChapter,
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
      ),
      body: getCurrentPage(),
    );
  }
}
