import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_drawer.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/featured_project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeaturedProjectsView extends StatefulWidget {
  const FeaturedProjectsView({
    Key? key,
    this.showSearchBar = false,
    this.embed = false,
  }) : super(key: key);

  static const String id = 'featured_projects_view';
  final bool showSearchBar;
  final bool embed;

  @override
  _FeaturedProjectsViewState createState() => _FeaturedProjectsViewState();
}

class _FeaturedProjectsViewState extends State<FeaturedProjectsView> {
  final TextEditingController _controller = TextEditingController();

  final ScrollController controller = ScrollController();

  late final FeaturedProjectsViewModel _model;

  List<Widget> _projects = [];

  void handleScrolling() {
    if (controller.offset >= controller.position.maxScrollExtent) {
      if (!widget.embed &&
          _model.previousProjectsBatch?.links.next != null &&
          !(_model.isBusy(_model.FETCH_FEATURED_PROJECTS) ||
              _model.isBusy(_model.SEARCH_PROJECTS))) {
        _model.loadMore();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(handleScrolling);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FeaturedProjectsViewModel>(
      onModelReady: (model) {
        _model = model;
        widget.embed
            ? model.fetchFeaturedProjects(size: 3)
            : model.fetchFeaturedProjects();
        Future.delayed(
          const Duration(milliseconds: 100),
          () => model.showSearchBar = widget.showSearchBar,
        );
      },
      builder: (context, model, child) {
        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_FEATURED_PROJECTS) ||
            model.isSuccess(model.SEARCH_PROJECTS)) {
          for (var project in model.projects) {
            _items.add(
              FeaturedProjectCard(
                project: project,
                onViewPressed: () async {
                  final _result = await Get.toNamed(
                    ProjectDetailsView.id,
                    arguments: project,
                  );

                  if (_result is Project) {
                    model.updateFeaturedProject(_result);
                  }
                },
              ),
            );
          }

          // add loading indicator if there are more projects to load..
          if (!widget.embed &&
              model.previousProjectsBatch?.links.next != null) {
            _items.add(const Center(
              child: CircularProgressIndicator(),
            ));
          }

          // maintaing another state of projects to prevent blank screen when
          // projects fetched from loadMore() is being added to the list..
          _projects = _items;
        }

        if (model.isSuccess(model.SEARCH_PROJECTS) &&
            model.projects.isEmpty &&
            model.showSearchedResult) {
          _items.addAll(
            [
              SvgPicture.asset(
                'assets/images/projects/noResult.svg',
                height: 400,
              ),
              Text(
                'No Result found',
                style: TextStyle(
                  fontSize: 16,
                  color: CVTheme.textColor(context),
                ),
              ),
            ],
          );
        }

        if (widget.embed) {
          return Column(
            children: _items,
          );
        }

        if (!model.showSearchBar) {
          _items.insert(
            0,
            const CVHeader(
              title: 'Editor Picks',
              description:
                  'These circuits have been hand-picked by our authors for their awesomeness.',
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: !model.showSearchBar,
            title: Visibility(
              visible: model.showSearchBar,
              replacement: Text(
                AppLocalizations.of(context)!.featured_circuits,
                style: TextStyle(
                  color: CVTheme.appBarText(context),
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context)
                      .colorScheme
                      .copyWith(primary: CVTheme.appBarText(context)),
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: CVTheme.appBarText(context),
                  ),
                ),
                child: CVTextField(
                  padding: EdgeInsets.zero,
                  prefixIcon: IconButton(
                    onPressed: () {
                      _controller.clear();
                      model.reset();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  hint: 'Search for circuits',
                  action: TextInputAction.search,
                  controller: _controller,
                  onFieldSubmitted: (value) {
                    model.query = value;
                    model.searchProjects(value);
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controller.clear();
                      model.clear();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
            elevation: 4,
            centerTitle: true,
            actions: [
              if (!model.showSearchBar)
                IconButton(
                  onPressed: () {
                    model.showSearchBar = true;
                  },
                  icon: const Icon(Icons.search),
                ),
            ],
          ),
          drawer: const CVDrawer(),
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                  controller: controller,
                  itemCount: _projects.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _projects[index];
                  })),
        );
      },
    );
  }
}
