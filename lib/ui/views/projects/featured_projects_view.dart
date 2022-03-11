import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/featured_project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';

class FeaturedProjectsView extends StatefulWidget {
  const FeaturedProjectsView({
    Key? key,
    this.showAppBar = true,
    this.embed = false,
  }) : super(key: key);

  static const String id = 'featured_projects_view';
  final bool showAppBar;
  final bool embed;

  @override
  _FeaturedProjectsViewState createState() => _FeaturedProjectsViewState();
}

class _FeaturedProjectsViewState extends State<FeaturedProjectsView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<FeaturedProjectsViewModel>(
      onModelReady: (model) => widget.embed
          ? model.fetchFeaturedProjects(size: 3)
          : model.fetchFeaturedProjects(),
      builder: (context, model, child) {
        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_FEATURED_PROJECTS)) {
          for (var project in model.featuredProjects) {
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
        }

        if (!widget.embed &&
            model.previousFeaturedProjectsBatch?.links.next != null) {
          _items.add(
            CVPrimaryButton(
              title: 'Load More',
              onPressed: () => model.fetchFeaturedProjects(),
            ),
          );
        }

        if (widget.embed) {
          return Column(
            children: _items,
          );
        }

        _items.insert(
          0,
          const CVHeader(
            title: 'Editor Picks',
            description:
                'These circuits have been hand-picked by our authors for their awesomeness.',
          ),
        );

        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(title: const Text('Featured Circuits'))
              : null,
          body: SingleChildScrollView(
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
