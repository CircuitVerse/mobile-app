import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/about/about_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/home/components/feature_card.dart';
import 'package:mobile_app/ui/views/profile/profile_view.dart';
import 'package:mobile_app/ui/views/projects/favourite_projects_view.dart';
import 'package:mobile_app/ui/views/projects/my_projects_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';
import 'package:mobile_app/viewmodels/home/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  static const String id = 'home_view';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    Widget _buildAppBar() {
      return AppBar(
        title: Text('CircuitVerse'),
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

    Widget _buildDrawer(HomeViewModel model) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'CircuitVerse',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3.copyWith(
                      fontFamily: 'Grinched',
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),
            InkWell(
              child: _buildDrawerTile('About', FontAwesome5.address_card),
              onTap: () => Get.offAndToNamed(AboutView.id),
            ),
            InkWell(
              child: _buildDrawerTile('Contribute', Icons.add),
              onTap: () => Get.offAndToNamed(ContributorsView.id),
            ),
            InkWell(
              child: _buildDrawerTile('Teachers', Icons.account_balance),
              onTap: () => Get.offAndToNamed(TeachersView.id),
            ),
            model.isLoggedIn
                ? ExpansionTile(
                    title: Text(
                      model.currentUserName,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    children: <Widget>[
                      InkWell(
                        child: _buildDrawerTile('Profile', FontAwesome5.user),
                        onTap: () => Get.offAndToNamed(ProfileView.id),
                      ),
                      InkWell(
                        child: _buildDrawerTile(
                            'My Projects', FontAwesome5.address_book),
                        onTap: () => Get.offAndToNamed(MyProjectsView.id),
                      ),
                      InkWell(
                        child: _buildDrawerTile(
                            'My Groups', FontAwesome5.object_group),
                        onTap: () => Get.offAndToNamed(MyGroupsView.id),
                      ),
                      InkWell(
                        child: _buildDrawerTile(
                            'My Favourites', Icons.bookmark_border),
                        onTap: () =>
                            Get.offAndToNamed(FavouriteProjectsView.id),
                      ),
                      InkWell(
                        child:
                            _buildDrawerTile('Log Out', Ionicons.ios_log_out),
                        onTap: () {
                          Get.back();
                          model.onLogout();
                        },
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

    Widget _buildHeader() {
      return Column(
        children: <Widget>[
          Text(
            'Dive into the world of Logic Circuits for free!',
            style: Theme.of(context).textTheme.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            'From Simple gates to complex sequential circuits, plot timimg diagrams, automatic circuit generation, explore standard ICs, and much more',
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    Widget _buildHomePageSketch() {
      return Image.asset(
        'assets/images/homepage/new-homepage-sketch.png',
        gaplessPlayback: true,
      );
    }

    Widget _buildTeachersAndContributorButtons() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 32),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            CVOutlineButton(
              title: 'For Teachers',
              onPressed: () => Get.toNamed(TeachersView.id),
              isBodyText: true,
            ),
            SizedBox(width: 16),
            CVOutlineButton(
              title: 'For Contributors',
              onPressed: () => Get.toNamed(ContributorsView.id),
              isBodyText: true,
            ),
          ],
        ),
      );
    }

    return BaseView<HomeViewModel>(
      builder: (context, model, child) => Scaffold(
        appBar: _buildAppBar(),
        drawer: _buildDrawer(model),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              _buildHeader(),
              _buildHomePageSketch(),
              _buildTeachersAndContributorButtons(),
              CVSubheader(
                title: 'Features',
                subtitle:
                    'Design circuits quickly and easily with a modern and intuitive user interface with drag-and-drop, copy/paste, zoom and more.',
              ),
              FeatureCard(
                assetPath: 'assets/images/homepage/export-hd.png',
                cardHeading: 'Explore High Resolution Images',
                cardDescription:
                    'CircuitVerse can export high resolution images in multiple formats including SVG.',
              ),
              FeatureCard(
                assetPath: 'assets/images/homepage/combinational-analysis.png',
                cardHeading: 'Combinational Analysis',
                cardDescription:
                    'Automatically generate circuit based on truth table data. This is great to create complex logic circuits and can be easily be made into a subcircuit.',
              ),
              FeatureCard(
                assetPath: 'assets/images/homepage/embed.png',
                cardHeading: 'Embed in Blogs',
                cardDescription:
                    'Since CircuitVerse is built in HTML5, an iFrame can be generated for each project allowing the user to embed it almost anywhere.',
              ),
              FeatureCard(
                assetPath: 'assets/images/homepage/sub-circuit.png',
                cardHeading: 'Use Sub circuits',
                cardDescription:
                    'Create subcircuits once and use them repeatedly. This allows easier and more structured design.',
              ),
              FeatureCard(
                assetPath: 'assets/images/homepage/multi-bit-bus.png',
                cardHeading: 'Multi Bit Buses and components',
                cardDescription:
                    'CircuitVerse supports multi bit wires, this means circuit design is easier, faster and uncluttered.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
