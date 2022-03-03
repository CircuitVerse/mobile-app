import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_add_icon_button.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_favourites_viewmodel.dart';
import 'package:provider/provider.dart';

class UserFavouritesView extends StatefulWidget {
  const UserFavouritesView({
    Key? key,
    this.userId,
  }) : super(key: key);

  final String? userId;

  @override
  _UserFavouritesViewState createState() => _UserFavouritesViewState();
}

class _UserFavouritesViewState extends State<UserFavouritesView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> onProjectCardPressed(Project project) async {}

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<UserFavouritesViewModel>(
      onModelReady: (model) {
        model.fetchUserFavourites(userId: widget.userId);
        context.watch<ProfileViewModel>().addListener(() {
          final project = context.read<ProfileViewModel>().updatedProject;
          if (project == null) return;
          model.onProjectChanged(project);
        });
      },
      builder: (context, model, child) {
        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_USER_FAVOURITES)) {
          for (var project in model.userFavourites) {
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

        if (model.previousUserFavouritesBatch?.links.next != null) {
          _items.add(
            CVAddIconButton(
              onPressed: () => model.fetchUserFavourites(userId: widget.userId),
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
