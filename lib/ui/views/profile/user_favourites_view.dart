import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_add_icon_button.dart';
import 'package:mobile_app/ui/components/cv_shimmer.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/projects/components/project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/profile/user_favourites_viewmodel.dart';

class UserFavouritesView extends StatefulWidget {
  final String userId;

  const UserFavouritesView({Key key, this.userId}) : super(key: key);

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
      onModelReady: (model) => model.fetchUserFavourites(userId: widget.userId),
      builder: (context, model, child) {
        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_USER_FAVOURITES)) {
          model.userFavourites.forEach((project) {
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
        } else if (model.isBusy(model.FETCH_USER_FAVOURITES)) {
          var _shimmerWidget = Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              height: 200.0,
              child: CVShimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: Card()),
            ),
          );
          _items.add(_shimmerWidget);
          _items.add(_shimmerWidget);
        }

        if (model?.previousUserFavouritesBatch?.links?.next != null) {
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
