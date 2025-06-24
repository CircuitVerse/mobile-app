import 'package:flutter/material.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/teachers/components/teachers_card.dart';

class TeachersView extends StatelessWidget {
  const TeachersView({super.key, this.showAppBar = true});

  static const String id = 'teachers_view';
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          children: <Widget>[
            CVHeader(
              title: AppLocalizations.of(context)!.teachers_title,
              description: AppLocalizations.of(context)!.teachers_description,
            ),
            CVSubheader(title: AppLocalizations.of(context)!.benefits_title),
            TeachersCard(
              assetPath: 'assets/images/teachers/groups.png',
              cardHeading:
                  AppLocalizations.of(context)!.teachers_feature1_title,
              cardDescription:
                  AppLocalizations.of(context)!.teachers_feature1_description,
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/assignment.png',
              cardHeading:
                  AppLocalizations.of(context)!.teachers_feature2_title,
              cardDescription:
                  AppLocalizations.of(context)!.teachers_feature2_description,
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/grading.png',
              cardHeading:
                  AppLocalizations.of(context)!.teachers_feature3_title,
              cardDescription:
                  AppLocalizations.of(context)!.teachers_feature3_description,
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/embed.png',
              cardHeading:
                  AppLocalizations.of(context)!.teachers_feature4_title,
              cardDescription:
                  AppLocalizations.of(context)!.teachers_feature4_description,
            ),
          ],
        ),
      ),
    );
  }
}
