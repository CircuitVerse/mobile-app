import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/model.dart';

class Navbar extends StatefulWidget {
  final bool isHomePage;
  final int chapterNumber;
  final int subChapterNumber;
  final void Function(bool) changeHomePage;
  final void Function(int, int) navigateToChapter;
  final Future<InteractiveBookNavbarModel> navbarData;

  const Navbar({
    super.key,
    required this.isHomePage,
    required this.chapterNumber,
    required this.subChapterNumber,
    required this.changeHomePage,
    required this.navigateToChapter,
    required this.navbarData,
  });

  @override
  State<Navbar> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(title: const Text("Interactive Book")),
        body: FutureBuilder<InteractiveBookNavbarModel>(
          future: widget.navbarData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final chapters = snapshot.data!.chapters;

            return ListView.builder(
              itemCount: chapters.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color:
                        widget.isHomePage
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                    child: ListTile(
                      leading: const Icon(Icons.home),
                      title: const Text(
                        'Home',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        widget.changeHomePage(true);
                        Navigator.pop(context);
                      },
                    ),
                  );
                }

                final chapter = chapters[index - 1];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: widget.chapterNumber == chapter.id,
                    title: Text(
                      chapter.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children:
                        chapter.subChapters.map((subChapter) {
                          return ListTile(
                            tileColor:
                                widget.chapterNumber == chapter.id &&
                                        widget.subChapterNumber == subChapter.id
                                    ? Colors.green[400]
                                    : null,
                            leading: const Icon(Icons.menu_book),
                            title: Text(subChapter.name),
                            onTap: () {
                              widget.navigateToChapter(
                                chapter.id,
                                subChapter.id,
                              );
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
