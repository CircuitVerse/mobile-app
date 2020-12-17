import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/home/components/feature_card.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
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
              isPrimaryDark: true,
              onPressed: () => Get.toNamed(TeachersView.id),
              isBodyText: true,
            ),
            SizedBox(width: 16),
            CVOutlineButton(
              title: 'For Contributors',
              isPrimaryDark: true,
              onPressed: () => Get.toNamed(ContributorsView.id),
              isBodyText: true,
            ),
          ],
        ),
      );
    }

    return BaseView<HomeViewModel>(
      builder: (context, model, child) => SingleChildScrollView(
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
            SizedBox(height: 16),
            CVSubheader(
              title: 'Editor Picks',
              subtitle:
                  'These circuits have been hand-picked by our authors for their awesomeness',
            ),
            FeaturedProjectsView(embed: true),
            CVOutlineButton(
              title: 'Explore More',
              isPrimaryDark: true,
              onPressed: () => Get.toNamed(FeaturedProjectsView.id),
            ),
          ],
        ),
      ),
    );
  }
}
