import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/featured_project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  @override
  Widget build(BuildContext context) {
    return BaseView<FeaturedProjectsViewModel>(
      onModelReady: (model) => widget.embed
          ? model.fetchFeaturedProjects(size: 3)
          : model.fetchFeaturedProjects(),
      builder: (context, model, child) {
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

        if (!widget.embed &&
            model?.previousFeaturedProjectsBatch?.links?.next != null) {
          _items.add(
            CVPrimaryButton(
              title: AppLocalizations.of(context).load_more,
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
          CVHeader(
            title: AppLocalizations.of(context).editor_picks,
            description: AppLocalizations.of(context).editor_picks_text,
          ),
        );

        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: Text(AppLocalizations.of(context).featured_circuits))
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
