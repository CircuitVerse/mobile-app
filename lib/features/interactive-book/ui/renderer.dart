import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/models.dart';
import 'package:mobile_app/features/interactive-book/ui/widgets/widgets.dart';
import 'package:mobile_app/features/interactive-book/services/service.dart';

class Renderer extends StatefulWidget {
  final int chapterNumber;
  final int subChapterNumber;
  final VoidCallback incrementChapter;
  final VoidCallback decrementChapter;

  const Renderer({
    super.key,
    required this.chapterNumber,
    required this.subChapterNumber,
    required this.incrementChapter,
    required this.decrementChapter,
  });

  @override
  State<Renderer> createState() => _RendererState();
}

class _RendererState extends State<Renderer> {
  late Future<ScreenModel> _future;

  @override
  void initState() {
    super.initState();
    _future = BookService().getChapters(
      subChapterId: widget.subChapterNumber.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant Renderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subChapterNumber != widget.subChapterNumber ||
        oldWidget.chapterNumber != widget.chapterNumber) {
      _future = BookService().getChapters(
        subChapterId: widget.subChapterNumber.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<ScreenModel>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final chapter = snapshot.data!;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        widget.decrementChapter();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        widget.incrementChapter();
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Forward'),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    itemCount: chapter.views.length,
                    itemBuilder: (context, index) {
                      final view = chapter.views[index];

                      switch (view) {
                        case TextModel():
                          return TextWidget(
                            size: view.size,
                            content: view.content,
                          );
                        case ChapterContentsModel():
                          return ChapterContentsWidget(items: view.items);
                        case ClipboardModel():
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Clipboard(content: view.content),
                          );
                        case TableModel():
                          return CustomTable(data: view);
                        case PopQuizModel():
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: PopQuizWidget(content: view.content),
                          );
                        case BinarySimulatorModel():
                          return const BinaryConverterWidget();

                        case PopQuizModel():
                          return PopQuizWidget(content: view.content);
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
