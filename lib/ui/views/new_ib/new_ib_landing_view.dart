import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/models/ib/new_ib_drawer_data.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_content.dart';
import 'package:mobile_app/ui/views/new_ib/components/new_ib_drawer.dart';
import 'package:mobile_app/viewmodels/ib/new_ib_landing_viewmodel.dart';

class NewInteractiveBookView extends StatefulWidget {
  const NewInteractiveBookView({super.key});

  static const String id = 'new_interactive_book_view';

  @override
  State<NewInteractiveBookView> createState() => _NewInteractiveBookViewState();
}

class _NewInteractiveBookViewState extends State<NewInteractiveBookView> {
  void _onChapterSelected(NewIbChapter? chapter) {
    // Will be implemented when we handle chapter navigation
  }

  void _onHomeSelected() {
    // Will be implemented when we handle home navigation
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<NewIbLandingViewModel>(
      onModelReady: (model) {
        model.init();
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
              onChapterSelected: _onChapterSelected,
              onHomeSelected: _onHomeSelected,
            ),
            body: NewIbContent(
              model: model,
              onNavigate: _onChapterSelected,
            ),
          ),
        );
      },
    );
  }
}
