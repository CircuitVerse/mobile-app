import 'package:flutter/material.dart';
import 'package:mobile_app/features/interactive-book/models/models.dart';
import 'package:mobile_app/features/interactive-book/models/page.dart';
import 'package:mobile_app/features/interactive-book/ui/widgets/widgets.dart';
import 'package:mobile_app/features/interactive-book/services/chapters.dart';

class Renderer extends StatefulWidget {
  /// Which page to fetch. About and Guidelines come from their own endpoints
  /// but return the same shape, so everything below this is shared.
  final IbPage page;
  final int chapterNumber;
  final int subChapterNumber;
  final bool showBackArrow;
  final bool showForwardArrow;
  final VoidCallback incrementChapter;
  final VoidCallback decrementChapter;
  final void Function(int, int) navigateToChapter;

  const Renderer({
    super.key,
    required this.page,
    required this.chapterNumber,
    required this.subChapterNumber,
    required this.showBackArrow,
    required this.showForwardArrow,
    required this.incrementChapter,
    required this.decrementChapter,
    required this.navigateToChapter,
  });

  @override
  State<Renderer> createState() => _RendererState();
}

class _RendererState extends State<Renderer> {
  late Future<ScreenModel> _future;
  final ScrollController _scrollController = ScrollController();

  final Map<int, GlobalKey> _sectionKeys = {};

  void scrollToSection(int scrollToId) {
    final key = _sectionKeys[scrollToId];

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildView(ViewModel view) {
    switch (view) {
      case TocModel():
        return TocWidget(chapters: view.items, onTap: scrollToSection);
      case TextModel():
        final textWidget = TextWidget(size: view.size, content: view.content);
        // Register an anchor so the TOC can scroll to this section.
        if (view.scrollToId != null) {
          final key = _sectionKeys.putIfAbsent(
            view.scrollToId!,
            () => GlobalKey(),
          );
          return KeyedSubtree(key: key, child: textWidget);
        }
        return textWidget;
      case ChapterContentsModel():
        return ChapterContentsWidget(
          items: view.items,
          chapterNumber: widget.chapterNumber,
          navigateToChapter: widget.navigateToChapter,
        );
      case ClipboardModel():
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ClipboardWidget(content: view.content),
        );
      case TableModel():
        return CustomTable(data: view);
      case GeneralModel():
        if (view.subType == 'binary-simulator') {
          return const BinaryConverterWidget();
        } else if (view.subType == 'character_representation') {
          return const CharacterRepresentationWidget();
        } else if (view.subType == 'click_gates') {
          return const SwitchLightWidget();
        } else if (view.subType == 'bitwise_operators') {
          return const BitwiseOperatorsWidget();
        } else {
          return const SizedBox.shrink();
        }
      case PopQuizModel():
        return PopQuizWidget(content: view.content);
      case BulletPointsModel():
        return BulletPointsWidget(bulletPoints: view.items);
      case NumberPointsModel():
        return NumberPointsWidget(items: view.items);
      case ImageModel():
        return ImageWidget(content: view.content);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<ScreenModel> _fetch() {
    if (widget.page == IbPage.about || widget.page == IbPage.guidelines) {
      return BookChaptersService().getStaticPage(widget.page);
    }
    return BookChaptersService().getChapters(
      chapterId: widget.chapterNumber.toString(),
      subChapterId: widget.subChapterNumber.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Renderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page ||
        oldWidget.subChapterNumber != widget.subChapterNumber ||
        oldWidget.chapterNumber != widget.chapterNumber) {
      _sectionKeys.clear();
      _future = _fetch();
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
                    if (widget.showBackArrow)
                      TextButton.icon(
                        onPressed: () {
                          widget.decrementChapter();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      ),
                    Spacer(),
                    if (widget.showForwardArrow)
                      TextButton.icon(
                        onPressed: () {
                          widget.incrementChapter();
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Forward'),
                      ),
                  ],
                ),
                Text(
                  chapter.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      for (final view in chapter.views) _buildView(view),
                    ],
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
