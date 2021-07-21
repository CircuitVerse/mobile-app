import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_drawer_tile.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:theme_provider/theme_provider.dart';

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
      title: Text(
        _appBarTitle(_selectedIndex),
        style: TextStyle(
          color: CVTheme.appBarText(context),
        ),
      ),
      centerTitle: true,
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
      SnackBarUtils.showDark(
        'Logged Out Successfully',
        'You have been signed out.',
      );
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 10),
                child: Image.asset(
                  'assets/images/landing/cv_full_logo.png',
                  width: 90,
                ),
              ),
              InkWell(
                onTap: () => setSelectedIndexTo(0),
                child: CVDrawerTile(title: 'Home', iconData: Icons.home),
              ),
              Theme(
                data: CVTheme.themeData(context),
                child: ExpansionTile(
                  maintainState: true,
                  title: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: Icon(
                      Icons.explore,
                      color: CVTheme.drawerIcon(context),
                    ),
                    title: Text(
                      'Explore',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  children: <Widget>[
                    InkWell(
                      onTap: () => setSelectedIndexTo(1),
                      child: CVDrawerTile(
                          title: 'Featured Circuits', iconData: Icons.star),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(IbLandingView.id),
                child: CVDrawerTile(
                    title: 'Interactive Book',
                    iconData: Icons.chrome_reader_mode),
              ),
              InkWell(
                onTap: () => setSelectedIndexTo(2),
                child: CVDrawerTile(
                    title: 'About', iconData: FontAwesome5.address_card),
              ),
              InkWell(
                onTap: () => setSelectedIndexTo(3),
                child: CVDrawerTile(title: 'Contribute', iconData: Icons.add),
              ),
              InkWell(
                onTap: () => setSelectedIndexTo(4),
                child: CVDrawerTile(
                    title: 'Teachers', iconData: Icons.account_balance),
              ),
              _model.isLoggedIn
                  ? Theme(
                      data: CVTheme.themeData(context),
                      child: ExpansionTile(
                        maintainState: true,
                        title: Text(
                          _model.currentUser.data.attributes.name ?? '',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        children: <Widget>[
                          InkWell(
                            onTap: () => setSelectedIndexTo(5),
                            child: CVDrawerTile(
                                title: 'Profile', iconData: FontAwesome5.user),
                          ),
                          InkWell(
                            onTap: () => setSelectedIndexTo(6),
                            child: CVDrawerTile(
                                title: 'My Groups',
                                iconData: FontAwesome5.object_group),
                          ),
                          InkWell(
                            onTap: onLogoutPressed,
                            child: CVDrawerTile(
                                title: 'Log Out',
                                iconData: Ionicons.ios_log_out),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () => Get.offAndToNamed(LoginView.id),
                      child: CVDrawerTile(
                          title: 'Login', iconData: Ionicons.ios_log_in),
                    )
            ],
          ),
          Positioned(
            right: 5,
            top: 35,
            child: IconButton(
                icon: Theme.of(context).brightness == Brightness.dark
                    ? const Icon(Icons.brightness_low)
                    : const Icon(Icons.brightness_high),
                iconSize: 28.0,
                onPressed: () {
                  if (ThemeProvider != null) {
                    ThemeProvider.controllerOf(context).nextTheme();
                  }
                }),
          ),
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
