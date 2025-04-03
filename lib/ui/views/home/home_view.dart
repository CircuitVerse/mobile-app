import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/ui/views/home/components/feature_card.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String id = 'home_view';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    Widget _buildHeader() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            Text(
              'Dive into the world of Logic Circuits for free!',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'From Simple gates to complex sequential circuits, plot timing diagrams, automatic circuit generation, explore standard ICs, and much more',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    Widget _buildHomePageSketch() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Image.asset(
          'assets/images/homepage/new-homepage-sketch.png',
          gaplessPlayback: true,
          fit: BoxFit.contain,
        ),
      );
    }

    Widget _buildTeachersAndContributorButtons() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CVOutlineButton(
                  title: 'For Teachers',
                  isPrimaryDark: true,
                  onPressed: () => Get.toNamed(TeachersView.id),
                  isBodyText: true,
                  leadingIcon: Icons.school,
                  minWidth: isWide ? 180 : 140,
                  maxWidth: isWide ? 180 : constraints.maxWidth * 0.8,
                ),
                SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                CVOutlineButton(
                  title: 'For Contributors',
                  isPrimaryDark: true,
                  onPressed: () => Get.toNamed(ContributorsView.id),
                  isBodyText: true,
                  leadingIcon: Icons.people_alt,
                  minWidth: isWide ? 180 : 140,
                  maxWidth: isWide ? 180 : constraints.maxWidth * 0.8,
                ),
              ],
            );
          },
        ),
      );
    }

    return BaseView<HomeViewModel>(
      builder:
          (context, model, child) => SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildHomePageSketch(),
                  _buildTeachersAndContributorButtons(),
                  const CVSubheader(
                    title: 'Features',
                    subtitle:
                        'Design circuits quickly and easily with a modern and intuitive user interface with drag-and-drop, copy/paste, zoom and more.',
                  ),
                  const FeatureCard(
                    assetPath: 'assets/images/homepage/export-hd.png',
                    cardHeading: 'Explore High Resolution Images',
                    cardDescription:
                        'CircuitVerse can export high resolution images in multiple formats including SVG.',
                  ),
                  const FeatureCard(
                    assetPath:
                        'assets/images/homepage/combinational-analysis.png',
                    cardHeading: 'Combinational Analysis',
                    cardDescription:
                        'Automatically generate circuit based on truth table data. This is great to create complex logic circuits and can be easily be made into a subcircuit.',
                  ),
                  const FeatureCard(
                    assetPath: 'assets/images/homepage/embed.png',
                    cardHeading: 'Embed in Blogs',
                    cardDescription:
                        'Since CircuitVerse is built in HTML5, an iFrame can be generated for each project allowing the user to embed it almost anywhere.',
                  ),
                  const FeatureCard(
                    assetPath: 'assets/images/homepage/sub-circuit.png',
                    cardHeading: 'Use Sub circuits',
                    cardDescription:
                        'Create subcircuits once and use them repeatedly. This allows easier and more structured design.',
                  ),
                  const FeatureCard(
                    assetPath: 'assets/images/homepage/multi-bit-bus.png',
                    cardHeading: 'Multi Bit Buses and components',
                    cardDescription:
                        'CircuitVerse supports multi bit wires, this means circuit design is easier, faster and uncluttered.',
                  ),
                  const SizedBox(height: 16),
                  const CVSubheader(
                    title: 'Editor Picks',
                    subtitle:
                        'These circuits have been hand-picked by our authors for their awesomeness',
                  ),
                  const FeaturedProjectsView(embed: true),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CVOutlineButton(
                      title: 'Explore More',
                      isPrimaryDark: true,
                      onPressed:
                          () =>
                              context.read<CVLandingViewModel>().selectedIndex =
                                  1,
                      minWidth: 180,
                      maxWidth: 300,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
