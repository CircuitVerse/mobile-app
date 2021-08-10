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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            AppLocalizations.of(context).home_main_heading,
            style: Theme.of(context).textTheme.headline4.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          Text(
            AppLocalizations.of(context).home_main_description,
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
              title: AppLocalizations.of(context).home_for_teachers,
              isPrimaryDark: true,
              onPressed: () => Get.toNamed(TeachersView.id),
              isBodyText: true,
            ),
            SizedBox(width: 16),
            CVOutlineButton(
              title: AppLocalizations.of(context).home_for_contributors,
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
              title: AppLocalizations.of(context).home_features,
              subtitle:
                  AppLocalizations.of(context).home_features_text,
            ),
            FeatureCard(
              assetPath: 'assets/images/homepage/export-hd.png',
              cardHeading: AppLocalizations.of(context).home_export_image,
              cardDescription:
                  AppLocalizations.of(context).home_export_image_text,
            ),
            FeatureCard(
              assetPath: 'assets/images/homepage/combinational-analysis.png',
              cardHeading: AppLocalizations.of(context).home_combinational_analysis,
              cardDescription:
                  AppLocalizations.of(context).home_combinational_analysis_text,
            ),
            FeatureCard(
              assetPath: 'assets/images/homepage/embed.png',
              cardHeading: AppLocalizations.of(context).home_embed,
              cardDescription:
                  AppLocalizations.of(context).home_embed_text,
            ),
            FeatureCard(
              assetPath: 'assets/images/homepage/sub-circuit.png',
              cardHeading: AppLocalizations.of(context).home_sub_circuits,
              cardDescription:
                  AppLocalizations.of(context).home_sub_circuits_text,
            ),
            FeatureCard(
              assetPath: 'assets/images/homepage/multi-bit-bus.png',
              cardHeading: AppLocalizations.of(context).home_multi_bit_buses,
              cardDescription:
                  AppLocalizations.of(context).home_multi_bit_buses_text,
            ),
            SizedBox(height: 16),
            CVSubheader(
              title: AppLocalizations.of(context).editor_picks,
              subtitle:
                  AppLocalizations.of(context).editor_picks_text,
            ),
            FeaturedProjectsView(embed: true),
            CVOutlineButton(
              title: AppLocalizations.of(context).home_explore_more,
              isPrimaryDark: true,
              onPressed: () => Get.toNamed(FeaturedProjectsView.id),
            ),
          ],
        ),
      ),
    );
  }
}
