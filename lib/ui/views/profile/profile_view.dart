import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/ui/components/cv_tab_bar.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/profile/user_favourites_view.dart';
import 'package:mobile_app/ui/views/profile/user_projects_view.dart';
import 'package:mobile_app/ui/views/profile/edit_profile_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key, this.userId});

  static const String id = 'profile_view';
  final String? userId;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late ProfileViewModel _model;

  Color _getUnselectedTabColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black87;
  }

  Widget _buildProfileImage() {
    final imageURL =
        EnvironmentConfig.CV_BASE_URL +
        (_model.user?.data.attributes.profilePicture ?? 'Default');
    return Container(
      key: const Key('profile_image'),
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: CVTheme.primaryColor.withAlpha(77), width: 3),
        image: DecorationImage(
          image:
              imageURL.toLowerCase().contains('default')
                  ? const AssetImage('assets/images/profile/default_icon.jpg')
                  : NetworkImage(imageURL) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNameComponent() {
    return Text(
      _model.user?.data.attributes.name ??
          AppLocalizations.of(context)!.profile_view_not_available,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }

  Widget _buildProfileComponent(IconData icon, String? description) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CVTheme.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: CVTheme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                description?.isEmpty ?? true
                    ? AppLocalizations.of(context)!.profile_view_not_available
                    : description!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    if (_model.isLoggedIn && _model.isPersonalProfile) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: CVTheme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () async {
            await Get.toNamed(EditProfileView.id)?.then((_updatedUser) {
              if (_updatedUser is User) {
                setState(() {
                  _model.user = _updatedUser;
                });
              }
              context.read<CVLandingViewModel>().onProfileUpdated();
            });
          },
          icon: const Icon(Icons.edit, color: Colors.white, size: 18),
          label: Text(
            AppLocalizations.of(context)!.profile_view_edit,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildProfileCard() {
    final _attrs = _model.user?.data.attributes;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: CVTheme.lightGrey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 16),
            _buildNameComponent(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withAlpha(153),
                ),
                const SizedBox(width: 6),
                Text(
                  _attrs?.createdAt != null
                      ? '${AppLocalizations.of(context)!.profile_view_joined} ${timeago.format(_attrs!.createdAt!)}'
                      : AppLocalizations.of(
                        context,
                      )!.profile_view_not_available,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withAlpha(153),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              children: [
                _buildProfileComponent(Icons.public, _attrs?.country),
                _buildProfileComponent(
                  Icons.school,
                  _attrs?.educationalInstitute,
                ),
                if (_model.isLoggedIn && _model.isPersonalProfile)
                  _buildProfileComponent(
                    _attrs?.subscribed == true
                        ? Icons.mail
                        : Icons.mail_outline,
                    _attrs?.subscribed == true
                        ? AppLocalizations.of(context)!.profile_view_yes
                        : AppLocalizations.of(context)!.profile_view_no,
                  ),
              ],
            ),
            _buildEditProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsTabBar() {
    if (_model.userId == null) return Container();

    // Calculate safe height constraints
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.6;
    final minHeight = maxHeight < 400 ? maxHeight : 400.0;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: CVTheme.lightGrey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight, maxHeight: maxHeight),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: CVTabBar(
              color: CVTheme.lightGrey.withValues(alpha: 0.2),
              tabBar: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: _getUnselectedTabColor(context),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: CVTheme.primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.profile_view_circuits,
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.profile_view_favourites,
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                UserProjectsView(userId: _model.userId!),
                UserFavouritesView(userId: _model.userId!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      onModelReady: (model) {
        _model = model;
        _model.userId = widget.userId;
        _model.fetchUserProfile();
      },
      builder:
          (context, model, child) => Scaffold(
            appBar:
                widget.userId != null
                    ? AppBar(
                      title: Text(
                        AppLocalizations.of(context)!.profile_view_title,
                      ),
                      centerTitle: true,
                    )
                    : null,
            body:
                _model.isSuccess(_model.FETCH_USER_PROFILE) ||
                        _model.user != null
                    ? SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: <Widget>[
                          _buildProfileCard(),
                          const SizedBox(height: 8),
                          _buildProjectsTabBar(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
