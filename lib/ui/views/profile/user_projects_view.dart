import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_add_icon_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';

class UserProjectsView extends StatefulWidget {
  final String userId;

  const UserProjectsView({Key key, this.userId}) : super(key: key);

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
      onModelReady: (model) => model.fetchUserProjects(userId: widget.userId),
      builder: (context, model, child) {
        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_USER_PROJECTS)) {
          model.userProjects.forEach((project) {
            _items.add(
              ProjectCard(
                project: project,
                isHeaderFilled: false,
                onPressed: () async {
                  var _result = await Get.toNamed(ProjectDetailsView.id,
                      arguments: project);
                  if (_result is bool) model.onProjectDeleted(project.id);
                },
              ),
            );
          });
        }

        if (model?.previousUserProjectsBatch?.links?.next != null) {
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
