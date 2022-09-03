import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/ui/components/cv_drawer.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/notifications/notifications_view.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CVLandingView extends StatefulWidget {
  const CVLandingView({Key? key}) : super(key: key);
  static const String id = 'cv_landing_view';

  @override
  _CVLandingViewState createState() => _CVLandingViewState();
}

class _CVLandingViewState extends State<CVLandingView> {
  // Global key
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _items = [
    const HomeView(),
    const FeaturedProjectsView(),
    const AboutView(),
    const ContributorsView(showAppBar: false),
    const TeachersView(showAppBar: false),
    const ProfileView(),
    const MyGroupsView(),
    // Featured Project View having search bar active
    const FeaturedProjectsView(showSearchBar: true),
    const NotificationsView(),
  ];

  String _appBarTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 1:
        return AppLocalizations.of(context)!.featured_circuits;
      case 5:
        return AppLocalizations.of(context)!.profile;
      case 6:
        return AppLocalizations.of(context)!.groups;
      case 8:
        return AppLocalizations.of(context)!.notifications;
      default:
        return AppLocalizations.of(context)!.title;
    }
  }

  AppBar? _buildAppBar(int selectedIndex, CVLandingViewModel model) {
    if (selectedIndex == 1 || selectedIndex == 7) return null;
    return AppBar(
      title: Text(
        _appBarTitle(selectedIndex),
        style: TextStyle(
          color: CVTheme.appBarText(context),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: Stack(
          children: [
            if (model.hasPendingNotif)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CVTheme.red,
                  ),
                ),
              ),
            const Center(child: Icon(Icons.menu)),
          ],
        ),
      ),
      centerTitle: true,
      elevation: selectedIndex == 6 ? 0 : 4,
      actions: [
        Visibility(
          visible: selectedIndex == 0,
          child: IconButton(
            onPressed: () {
              model.selectedIndex = 7;
            },
            icon: const Icon(Icons.search),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CVLandingViewModel>(
      onModelReady: (model) => model.setUser(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          if (model.selectedIndex != 0) {
            model.selectedIndex = 0;
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(model.selectedIndex, model),
          drawer: const CVDrawer(),
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
            child: _items.elementAt(model.selectedIndex),
          ),
        ),
      ),
    );
  }
}
