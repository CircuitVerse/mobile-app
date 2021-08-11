import 'package:flutter/material.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/teachers/components/teachers_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeachersView extends StatelessWidget {
  static const String id = 'teachers_view';
  final bool showAppBar;

  const TeachersView({Key key, this.showAppBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CVHeader(
              title: AppLocalizations.of(context).teachers,
              description: AppLocalizations.of(context).teachers_text,
            ),
            CVSubheader(title: AppLocalizations.of(context).teachers_benefits),
            TeachersCard(
              assetPath: 'assets/images/teachers/groups.png',
              cardHeading: AppLocalizations.of(context).teachers_create_group,
              cardDescription:
                  AppLocalizations.of(context).teachers_create_group_text,
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/assignment.png',
              cardHeading:
                  AppLocalizations.of(context).teachers_post_assignments,
              cardDescription:
                  AppLocalizations.of(context).teachers_post_assignment_text,
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/grading.png',
              cardHeading:
                  AppLocalizations.of(context).teachers_grading_assignment,
              cardDescription:
                  AppLocalizations.of(context).teachers_grading_assignment_text,
            ),
            TeachersCard(
              assetPath: 'assets/images/teachers/embed.png',
              cardHeading:
                  AppLocalizations.of(context).teachers_use_interactive_circuit,
              cardDescription: AppLocalizations.of(context)
                  .teachers_use_interactive_circuit_text,
            ),
          ],
        ),
      ),
    );
  }
}
