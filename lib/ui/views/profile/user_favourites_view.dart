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
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class UserFavouritesView extends StatefulWidget {
  const UserFavouritesView({super.key, this.userId});

  static const String id = 'user_favourites_view';
  final String? userId;

  @override
  _UserFavouritesViewState createState() => _UserFavouritesViewState();
}

class _UserFavouritesViewState extends State<UserFavouritesView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> onProjectCardPressed(Project project) async {}

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          _buildSubHeader(
            title: AppLocalizations.of(context)!.no_favorites_title,
            subtitle: AppLocalizations.of(context)!.no_favorites_subtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildSubHeader({required String title, String? subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

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
        if (model.isBusy(model.FETCH_USER_FAVOURITES)) {
          return const Column(
            children: [
              SizedBox(height: 120),
              Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ],
          );
        }

        final _items = <Widget>[];

        if (model.isSuccess(model.FETCH_USER_FAVOURITES)) {
          if (model.userFavourites.isEmpty) {
            _items.add(_emptyState());
          } else {
            for (var project in model.userFavourites) {
              _items.add(
                ProjectCard(
                  project: project,
                  isHeaderFilled: false,
                  onPressed: () async {
                    var _result = await Get.toNamed(
                      ProjectDetailsView.id,
                      arguments: project,
                    );
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
        }

        if (model.previousUserFavouritesBatch?.links.next != null) {
          _items.add(
            CVAddIconButton(
              onPressed: () => model.fetchUserFavourites(userId: widget.userId),
            ),
          );
        }

        return ListView(padding: const EdgeInsets.all(8), children: _items);
      },
    );
  }
}
