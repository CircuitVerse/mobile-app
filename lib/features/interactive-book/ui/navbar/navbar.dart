import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/model.dart';
import 'package:mobile_app/features/interactive-book/ui/navbar/service.dart';

class Navbar extends StatefulWidget {
final bool isHomePage;
final int chapterNumber;
final int subChapterNumber;

  @Preview(name: "Navbar")
  const Navbar({super.key, required this.isHomePage, required this.chapterNumber, required this.subChapterNumber});

  @override
  State<Navbar> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<Navbar> {
  late Future<BookResponse> future;

  @override
  void initState() {
    super.initState();
    future = BookService().getChapters();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(title: const Text("Interactive Book")),
        body: FutureBuilder<BookResponse>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final chapters = snapshot.data!.chapters;

            return ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];

                

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      chapter.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children:
                        chapter.subChapters.map((subChapter) {
                          return ListTile(
                            leading: const Icon(Icons.menu_book),
                            title: Text(subChapter.name),
                            onTap: () {
                              debugPrint(
                                "Selected ${chapter.name} -> ${subChapter.name}",
                              );
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
