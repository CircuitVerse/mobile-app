import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/featured_project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';

class FeaturedProjectsView extends StatefulWidget {
  static const String id = 'featured_projects_view';
  final bool showAppBar;
  final bool embed;

  const FeaturedProjectsView(
      {Key key, this.showAppBar = true, this.embed = false})
      : super(key: key);

  @override
  _FeaturedProjectsViewState createState() => _FeaturedProjectsViewState();
}

class _FeaturedProjectsViewState extends State<FeaturedProjectsView> {
  final _scrollController = ScrollController();
  bool addedListener =
      false; //Flag to know if a listener is already added to the controller or not.

  dynamic _scrollListener(FeaturedProjectsViewModel model) {
    var maxScroll = _scrollController.position.maxScrollExtent;
    var currentScroll = _scrollController.position.pixels;
    var delta =
        200; // Loads more data if "delta" pixels left to reach maxScrollExtent
    if (maxScroll - currentScroll <= delta) {
      if (!model.isLoadingMoreCircuits &&
          model?.previousFeaturedProjectsBatch?.links?.next != null) {
        model.fetchFeaturedProjects();
      }
    }
    addedListener = true;
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<FeaturedProjectsViewModel>(
      onModelReady: (model) => widget.embed
          ? model.fetchFeaturedProjects(size: 3)
          : model.fetchFeaturedProjects(),
      builder: (context, model, child) {
        if (!addedListener) {
          _scrollController.addListener(() => _scrollListener(model));
        }

        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_FEATURED_PROJECTS)) {
          model.featuredProjects.forEach((project) {
            _items.add(
              FeaturedProjectCard(
                project: project,
                onViewPressed: () async {
                  await Get.toNamed(ProjectDetailsView.id, arguments: project);
                },
              ),
            );
          });
        }

        if (widget.embed) {
          return Column(
            children: _items,
          );
        }

        _items.insert(
          0,
          CVHeader(
            title: 'Editor Picks',
            description:
                'These circuits have been hand-picked by our authors for their awesomeness.',
          ),
        );
        if (model.isLoadingMoreCircuits) {
          _items.add(CircularProgressIndicator());
        }
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(title: Text('Featured Circuits'))
              : null,
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _items,
            ),
          ),
        );
      },
    );
  }
}
