import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';

class CVLandingView extends StatefulWidget {
  static const String id = 'cv_landing_view';

  @override
  _CVLandingViewState createState() => _CVLandingViewState();
}

class _CVLandingViewState extends State<CVLandingView> {
  final DialogService _dialogService = locator<DialogService>();
  CVLandingViewModel _model;
  int _selectedIndex = 0;

  final List<Widget> _items = [
    HomeView(),
    FeaturedProjectsView(showAppBar: false),
    AboutView(),
    ContributorsView(showAppBar: false),
    TeachersView(showAppBar: false),
    ProfileView(),
    MyGroupsView(),
  ];

  void setSelectedIndexTo(int index) {
    Get.back();
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  String _appBarTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        return 'Featured Circuits';
        break;
      case 5:
        return 'Profile';
        break;
      case 6:
        return 'Groups';
        break;
      default:
        return 'CircuitVerse';
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(_appBarTitle(_selectedIndex)),
      centerTitle: true,
    );
  }

  Widget _buildDrawerTile(String title, IconData iconData) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Future<void> onLogoutPressed() async {
    Get.back();

    var _dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Log Out',
      description: 'Are you sure you want to logout?',
      confirmationTitle: 'LOGOUT',
    );

    if (_dialogResponse.confirmed) {
      _model.onLogout();
      setState(() => _selectedIndex = 0);
      SnackBarUtils.showDark('Logged Out Successfully');
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
            child: Image.asset(
              'assets/images/landing/cv_full_logo.png',
              width: 90,
            ),
          ),
          InkWell(
            child: _buildDrawerTile('Home', Icons.home),
            onTap: () => setSelectedIndexTo(0),
          ),
          ExpansionTile(
            maintainState: true,
            title: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(Icons.explore),
              title: Text(
                'Explore',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            children: <Widget>[
              InkWell(
                child: _buildDrawerTile('Featured Circuits', Icons.star),
                onTap: () => setSelectedIndexTo(1),
              ),
            ],
          ),
          InkWell(
            child: _buildDrawerTile('About', FontAwesome5.address_card),
            onTap: () => setSelectedIndexTo(2),
          ),
          InkWell(
            child: _buildDrawerTile('Contribute', Icons.add),
            onTap: () => setSelectedIndexTo(3),
          ),
          InkWell(
            child: _buildDrawerTile('Teachers', Icons.account_balance),
            onTap: () => setSelectedIndexTo(4),
          ),
          _model.isLoggedIn
              ? ExpansionTile(
                  maintainState: true,
                  title: Text(
                    _model.currentUser.data.attributes.name ?? '',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  children: <Widget>[
                    InkWell(
                      child: _buildDrawerTile('Profile', FontAwesome5.user),
                      onTap: () => setSelectedIndexTo(5),
                    ),
                    InkWell(
                      child: _buildDrawerTile(
                          'My Groups', FontAwesome5.object_group),
                      onTap: () => setSelectedIndexTo(6),
                    ),
                    InkWell(
                      child: _buildDrawerTile('Log Out', Ionicons.ios_log_out),
                      onTap: onLogoutPressed,
                    ),
                  ],
                )
              : InkWell(
                  child: _buildDrawerTile('Login', Ionicons.ios_log_in),
                  onTap: () => Get.offAndToNamed(LoginView.id),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CVLandingViewModel>(
      onModelReady: (model) {
        _model = model;
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          drawer: _buildDrawer(),
          body: PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: _items.elementAt(_selectedIndex),
          ),
        ),
      ),
    );
  }
}
