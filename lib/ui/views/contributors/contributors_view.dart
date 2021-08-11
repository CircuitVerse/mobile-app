import 'package:flutter/material.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_social_card.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_donate_card.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_support_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContributorsView extends StatelessWidget {
  static const String id = 'contributors_view';
  final bool showAppBar;

  const ContributorsView({Key key, this.showAppBar = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar() : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CVHeader(
              title: AppLocalizations.of(context).contribute,
              description:
                  AppLocalizations.of(context).contributors_main_description,
            ),
            CircuitVerseSocialCard(
              imagePath: 'assets/images/contribute/email.png',
              title: AppLocalizations.of(context).email_us_at,
              description: 'support@circuitverse.org',
              url: 'mailto:support@circuitverse.org',
            ),
            CircuitVerseSocialCard(
              imagePath: 'assets/images/contribute/slack.png',
              title: AppLocalizations.of(context).join_slack,
              description: AppLocalizations.of(context).slack_channel,
              url: 'https://circuitverse.org/slack',
            ),
            CircuitVerseSocialCard(
              imagePath: 'assets/images/contribute/github.png',
              title: AppLocalizations.of(context)
                  .contributors_contribute_to_open_source,
              description: AppLocalizations.of(context).contributors_github,
              url: 'https://github.com/CircuitVerse',
            ),
            SizedBox(height: 32),
            CVSubheader(
                title:
                    AppLocalizations.of(context).contributors_how_to_support),
            ContributeSupportCard(
              imagePath: 'assets/images/contribute/person.png',
              title:
                  AppLocalizations.of(context).contributors_student_card_title,
              cardDescriptionList: [
                AppLocalizations.of(context).contributors_student_card_text1,
                AppLocalizations.of(context).contributors_student_card_text2,
                AppLocalizations.of(context).contributors_student_card_text3
              ],
            ),
            ContributeSupportCard(
              imagePath: 'assets/images/contribute/professor.png',
              title:
                  AppLocalizations.of(context).contributors_teacher_card_title,
              cardDescriptionList: [
                AppLocalizations.of(context).contributors_teacher_card_text1,
                AppLocalizations.of(context).contributors_teacher_card_text2,
                AppLocalizations.of(context).contributors_teacher_card_text3
              ],
            ),
            ContributeSupportCard(
              imagePath: 'assets/images/contribute/person.png',
              title: AppLocalizations.of(context)
                  .contributors_developer_card_title,
              cardDescriptionList: [
                AppLocalizations.of(context).contributors_developer_card_text1,
                AppLocalizations.of(context).contributors_developer_card_text2,
                AppLocalizations.of(context).contributors_developer_card_text3
              ],
            ),
            SizedBox(height: 16),
            ContributeDonateCard(
              imagePath: 'assets/images/contribute/patreon-logo.png',
              title: AppLocalizations.of(context).contributors_become_patreon,
              url: 'https://www.patreon.com/CircuitVerse',
            ),
            SizedBox(height: 16),
            ContributeDonateCard(
              imagePath: 'assets/images/contribute/paypal-logo.jpg',
              title:
                  AppLocalizations.of(context).contributors_donate_via_paypal,
              url: 'https://www.paypal.me/satviksr',
            )
          ],
        ),
      ),
    );
  }
}
