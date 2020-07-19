import 'package:flutter/material.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_social_card.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_donate_card.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_support_card.dart';

class ContributorsView extends StatelessWidget {
  static const String id = 'contributors_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CVHeader(
              title: 'CONTRIBUTE',
              description:
                  "CircuitVerse aims to be free forever and we promise that we won't run any ads! The project is open source and to ensure its continued development and maintenance we need your support.",
            ),
            CircuitVerseSocialCard(
              imagePath: 'assets/images/contribute/email.png',
              title: 'Email us at',
              description: 'support@circuitverse.org',
              url: 'mailto:support@circuitverse.org',
            ),
            CircuitVerseSocialCard(
              imagePath: 'assets/images/contribute/slack.png',
              title: 'Join and chat with us at',
              description: 'Slack channel',
              url:
                  'https://join.slack.com/t/circuitverse-team/shared_invite/enQtNjc4MzcyNDE5OTA3LTdjYTM5NjFiZWZlZGI2MmU1MmYzYzczNmZlZDg5MjYxYmQ4ODRjMjQxM2UyMWI5ODUzODQzMDU2ZDEzNjI4NmE',
            ),
            CircuitVerseSocialCard(
              imagePath: 'assets/images/contribute/github.png',
              title: 'Contribute to open source',
              description: 'Github',
              url: 'https://github.com/CircuitVerse',
            ),
            CVSubheader(title: 'How to Support ?'),
            ContributeSupportCard(
              imagePath: 'assets/images/contribute/person.png',
              title: 'I am a Student',
              cardDescriptionList: [
                'Create amazing circuits and share on the platform',
                'Find and report bugs. Become a bug hunter',
                'Introduce the platform to your buddie'
              ],
            ),
            ContributeSupportCard(
              imagePath: 'assets/images/contribute/professor.png',
              title: 'I am a Teacher',
              cardDescriptionList: [
                'Introduce the platform to your students',
                'Promote the platform within your circles',
                'Create exciting educational content using CircuitVerse'
              ],
            ),
            ContributeSupportCard(
              imagePath: 'assets/images/contribute/person.png',
              title: 'I am a Developer',
              cardDescriptionList: [
                'Contribute to the OpenSource projects',
                'Add and propose new features to the projects',
                'Find and fix bugs in the CircuitVerse projects'
              ],
            ),
            SizedBox(height: 16),
            ContributeDonateCard(
              imagePath: 'assets/images/contribute/patreon-logo.png',
              title: 'Become a Patreon',
              url: 'https://www.patreon.com/CircuitVerse',
            ),
            SizedBox(height: 16),
            ContributeDonateCard(
              imagePath: 'assets/images/contribute/paypal-logo.jpg',
              title: 'Donate through PayPal',
              url: 'https://www.paypal.me/satviksr',
            )
          ],
        ),
      ),
    );
  }
}
