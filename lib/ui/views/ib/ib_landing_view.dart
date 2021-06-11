import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ib_theme.dart';
import 'package:mobile_app/ui/components/cv_drawer_tile.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/ib/ib_page_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:theme_provider/theme_provider.dart';

class IbLandingView extends StatefulWidget {
  static const String id = 'ib_landing_view';

  @override
  _IbLandingViewState createState() => _IbLandingViewState();
}

class _IbLandingViewState extends State<IbLandingView> {
  int _selectedIndex = 0;
  Function _onTocPressed;

  void setSelectedIndexTo(int index) {
    Get.back();
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  String _appBarTitle(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return 'CircuitVerse';
        break;
      default:
        return 'Interactive Book';
    }
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        _appBarTitle(_selectedIndex),
      ),
      actions: _onTocPressed != null
          ? [
              IconButton(
                icon: const Icon(Icons.menu_book_rounded),
                tooltip: 'Show Table of Contents',
                onPressed: _onTocPressed,
              ),
            ]
          : [],
      centerTitle: true,
      brightness: Brightness.dark,
    );
  }

  Widget _buildExpandableChapter() {
    return ExpansionTile(
      maintainState: true,
      title: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: GestureDetector(
          onTap: () => setSelectedIndexTo(0),
          child: Text(
            'Binary algebra',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      children: <Widget>[
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Addition'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Substraction'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Multiplication'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Division'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Boolean algebra'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Boolean functions'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'Shannon decomposition'),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(title: 'IEEE Std 754'),
        ),
      ],
    );
  }

  Widget _buildChapters() {
    return Column(
      children: [
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(
            title: 'Binary Representation',
          ),
        ),
        _buildExpandableChapter(),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(
            title: 'Guidelines',
          ),
        ),
        InkWell(
          onTap: () => setSelectedIndexTo(0),
          child: CVDrawerTile(
            title: 'About',
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Get.back();
                  Get.back();
                },
                child: CVDrawerTile(title: 'Return to Home'),
              ),
              Divider(thickness: 1),
              InkWell(
                onTap: () => setSelectedIndexTo(0),
                child: CVDrawerTile(
                  title: 'Interactive Book Home',
                  color: IbTheme.getPrimaryColor(context),
                ),
              ),
              _buildChapters(),
            ],
          ),
          Positioned(
            right: 5,
            top: 27,
            child: IconButton(
              icon: Theme.of(context).brightness == Brightness.dark
                  ? const Icon(Icons.brightness_low)
                  : const Icon(Icons.brightness_high),
              iconSize: 28.0,
              onPressed: () {
                if (ThemeProvider != null) {
                  ThemeProvider.controllerOf(context).nextTheme();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CVLandingViewModel>(
      onModelReady: (model) {
        //_model = model;
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          if (_selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Theme(
          data: IbTheme.getThemeData(context),
          child: Scaffold(
            key: Key('IbLandingScaffold'),
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
              child: IbPageView(
                tocCallback: (val) {
                  Future.delayed(Duration.zero, () async {
                    setState(() => _onTocPressed = val);
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
