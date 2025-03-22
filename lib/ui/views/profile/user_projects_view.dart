import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_add_icon_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:provider/provider.dart';

class UserProjectsView extends StatefulWidget {
  const UserProjectsView({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  _UserProjectsViewState createState() => _UserProjectsViewState();
}

class _UserProjectsViewState extends State<UserProjectsView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<UserProjectsViewModel>(
      onModelReady: (model) {
        model.fetchUserProjects(userId: widget.userId);
        context.watch<ProfileViewModel>().addListener(() {
          var updatedProject = context.read<ProfileViewModel>().updatedProject;
          if (updatedProject == null) return;
          model.onProjectChanged(updatedProject);
        });
      },
      builder: (context, model, child) {
        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_USER_PROJECTS)) {
          for (var project in model.userProjects) {
            _items.add(
              ProjectCard(
                project: project,
                isHeaderFilled: false,
                onPressed: () async {
                  var _result = await Get.toNamed(ProjectDetailsView.id,
                      arguments: project);
                  if (_result is bool) model.onProjectDeleted(project.id);
                  if (_result is Project) {
                    model.onProjectChanged(_result);
                    context.read<ProfileViewModel>().updatedProject = _result;
                  }
                },
              ),
            );
          }
        }

        if (model.previousUserProjectsBatch?.links.next != null) {
          _items.add(
            CVAddIconButton(
              onPressed: () => model.fetchUserProjects(userId: widget.userId),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(8),
          children: _items,
        );
      },
    );
  }
}
