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
import 'package:mobile_app/gen_l10n/app_localizations.dart';

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
              AppLocalizations.of(context)!.home_header_title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.home_header_subtitle,
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
                  title: AppLocalizations.of(context)!.teachers_button,
                  isPrimaryDark: true,
                  onPressed: () => Get.toNamed(TeachersView.id),
                  isBodyText: true,
                  leadingIcon: Icons.school,
                  minWidth: isWide ? 180 : 140,
                  maxWidth: isWide ? 180 : constraints.maxWidth * 0.8,
                ),
                SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                CVOutlineButton(
                  title: AppLocalizations.of(context)!.contributors_button,
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
                  CVSubheader(
                    title: AppLocalizations.of(context)!.features_title,
                    subtitle: AppLocalizations.of(context)!.features_subtitle,
                  ),
                  FeatureCard(
                    assetPath: 'assets/images/homepage/export-hd.png',
                    cardHeading: AppLocalizations.of(context)!.feature1_title,
                    cardDescription:
                        AppLocalizations.of(context)!.feature1_description,
                  ),
                  FeatureCard(
                    assetPath:
                        'assets/images/homepage/combinational-analysis.png',
                    cardHeading: AppLocalizations.of(context)!.feature2_title,
                    cardDescription:
                        AppLocalizations.of(context)!.feature2_description,
                  ),
                  FeatureCard(
                    assetPath: 'assets/images/homepage/embed.png',
                    cardHeading: AppLocalizations.of(context)!.feature3_title,
                    cardDescription:
                        AppLocalizations.of(context)!.feature3_description,
                  ),
                  FeatureCard(
                    assetPath: 'assets/images/homepage/sub-circuit.png',
                    cardHeading: AppLocalizations.of(context)!.feature4_title,
                    cardDescription:
                        AppLocalizations.of(context)!.feature4_description,
                  ),
                  FeatureCard(
                    assetPath: 'assets/images/homepage/multi-bit-bus.png',
                    cardHeading: AppLocalizations.of(context)!.feature5_title,
                    cardDescription:
                        AppLocalizations.of(context)!.feature5_description,
                  ),
                  const SizedBox(height: 16),
                  CVSubheader(
                    title: AppLocalizations.of(context)!.editor_picks_title,
                    subtitle:
                        AppLocalizations.of(context)!.editor_picks_subtitle,
                  ),
                  const FeaturedProjectsView(embed: true),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CVOutlineButton(
                      title: AppLocalizations.of(context)!.explore_more_button,
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
