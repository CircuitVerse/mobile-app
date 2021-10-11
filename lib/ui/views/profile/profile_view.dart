import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/components/cv_tab_bar.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/profile/user_favourites_view.dart';
import 'package:mobile_app/ui/views/profile/user_projects_view.dart';
import 'package:mobile_app/ui/views/profile/edit_profile_view.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileView extends StatefulWidget {
  static const String id = 'profile_view';
  final String userId;

  const ProfileView({Key key, this.userId}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileViewModel _model;
  String userId;

  @override
  void initState() {
    super.initState();
    userId =
        widget.userId ?? locator<LocalStorageService>().currentUser.data.id;
  }

  Widget _buildProfileImage() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        'assets/images/profile/profile_default.png',
        width: 80,
      ),
    );
  }

  Widget _buildNameComponent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        _model?.user?.data?.attributes?.name ?? 'N.A',
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildProfileComponent(String title, String description) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyText1,
          children: <TextSpan>[
            TextSpan(
              text: '$title : ',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextSpan(
              text: description?.isEmpty ?? true ? 'N.A' : description,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileButton() {
    var _localStorageService = locator<LocalStorageService>();
    if (_localStorageService.isLoggedIn &&
        userId == _localStorageService.currentUser.data.id) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: CVTheme.primaryColor,
        ),
        onPressed: () async {
          var _updatedUser = await Get.toNamed(EditProfileView.id);
          if (_updatedUser is User) {
            setState(() {
              _model.user = _updatedUser;
            });
          }
        },
        child: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.white,
              ),
        ),
      );
    }

    return Container();
  }

  Widget _buildProfileCard() {
    var _attrs = _model?.user?.data?.attributes;

    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: CVTheme.lightGrey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  _buildProfileImage(),
                  _buildNameComponent(),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProfileComponent(
                    'Joined',
                    _attrs?.createdAt != null
                        ? timeago.format(_attrs.createdAt)
                        : null,
                  ),
                  _buildProfileComponent(
                    'Country',
                    _attrs?.country,
                  ),
                  _buildProfileComponent(
                    'Educational Institute',
                    _attrs?.educationalInstitute,
                  ),
                  _buildProfileComponent(
                    'Subscribed to mails',
                    _attrs?.subscribed.toString(),
                  ),
                  _buildEditProfileButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsTabBar() {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: CVTheme.lightGrey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: CVTabBar(
              color: CVTheme.lightGrey.withOpacity(0.2),
              tabBar: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black87,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: CVTheme.primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                ),
                tabs: [
                  Tab(text: 'Circuits'),
                  Tab(text: 'Favourites'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                UserProjectsView(userId: userId),
                UserFavouritesView(userId: userId),
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
        _model.fetchUserProfile(userId);
      },
      builder: (context, model, child) => Scaffold(
        appBar: widget.userId != null
            ? AppBar(
                title: const Text('Profile'),
                centerTitle: true,
              )
            : null,
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              _buildProfileCard(),
              const SizedBox(height: 8),
              _buildProjectsTabBar(),
            ],
          ),
        ),
      ),
    );
  }
}
