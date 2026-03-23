import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_content.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';

class NewInteractiveBookView extends StatefulWidget {
  const NewInteractiveBookView({super.key});

  static const String id = 'new_interactive_book_view';

  @override
  State<NewInteractiveBookView> createState() => _NewInteractiveBookViewState();
}

class _NewInteractiveBookViewState extends State<NewInteractiveBookView> {
  IbChapter? _selectedChapter;

  void _onChapterSelected(IbChapter? chapter) {
    setState(() {
      _selectedChapter = chapter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<IbLandingViewModel>(
      onModelReady: (model) {
        model.init();
        _selectedChapter = model.homeChapter;
      },
      builder: (context, model, child) {
        return Theme(
          data: IbTheme.getThemeData(context),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Interactive Book'),
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () {},
                  tooltip: 'Search',
                ),
              ],
            ),
            drawer: NewIbDrawer(
              model: model,
              selectedChapter: _selectedChapter,
              onChapterSelected: _onChapterSelected,
            ),
            body: NewIbContent(
              selectedChapter: _selectedChapter,
              homeChapter: model.homeChapter,
              onNavigate: _onChapterSelected,
            ),
          ),
        );
      },
    );
  }
}
