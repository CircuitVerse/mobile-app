import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_social_card.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_donate_card.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_support_card.dart';

class ContributorsView extends StatelessWidget {
  const ContributorsView({super.key, this.showAppBar = true});

  static const String id = 'contributors_view';
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
              title: AppLocalizations.of(context)!.contribute_title,
              description: AppLocalizations.of(context)!.contribute_description,
            ),
            const SizedBox(height: 24),
            _buildConnectSection(context),
            const SizedBox(height: 40),
            _buildSupportSection(context),
            const SizedBox(height: 40),
            _buildDonateSection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.connect_without_contact,
              color: CVTheme.primaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Connect With Us',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: CVTheme.highlightText(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CircuitVerseSocialCard(
          imagePath: 'assets/images/contribute/email.png',
          title: AppLocalizations.of(context)!.email_us_title,
          description: 'support@circuitverse.org',
          url: 'mailto:support@circuitverse.org',
        ),
        const SizedBox(height: 8),
        CircuitVerseSocialCard(
          imagePath: 'assets/images/contribute/slack.png',
          title: AppLocalizations.of(context)!.join_chat_title,
          description: AppLocalizations.of(context)!.slack_channel,
          url: 'https://circuitverse.org/slack',
        ),
        const SizedBox(height: 8),
        CircuitVerseSocialCard(
          imagePath: 'assets/images/contribute/github.png',
          title: AppLocalizations.of(context)!.open_source_title,
          description: 'GitHub',
          url: 'https://github.com/CircuitVerse',
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.volunteer_activism,
              color: CVTheme.primaryColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CVSubheader(
                title: AppLocalizations.of(context)!.how_to_support,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ContributeSupportCard(
          imagePath: 'assets/images/contribute/person.png',
          title: AppLocalizations.of(context)!.student_role,
          cardDescriptionList: [
            AppLocalizations.of(context)!.student_support1,
            AppLocalizations.of(context)!.student_support2,
            AppLocalizations.of(context)!.student_support3,
          ],
        ),
        ContributeSupportCard(
          imagePath: 'assets/images/contribute/professor.png',
          title: AppLocalizations.of(context)!.teacher_role,
          cardDescriptionList: [
            AppLocalizations.of(context)!.teacher_support1,
            AppLocalizations.of(context)!.teacher_support2,
            AppLocalizations.of(context)!.teacher_support3,
          ],
        ),
        ContributeSupportCard(
          imagePath: 'assets/images/contribute/person.png',
          title: AppLocalizations.of(context)!.developer_role,
          cardDescriptionList: [
            AppLocalizations.of(context)!.developer_support1,
            AppLocalizations.of(context)!.developer_support2,
            AppLocalizations.of(context)!.developer_support3,
          ],
        ),
      ],
    );
  }

  Widget _buildDonateSection(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.favorite,
              color: CVTheme.red,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'Support Our Mission',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: CVTheme.highlightText(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Your donations help us keep CircuitVerse free and accessible to everyone',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: CVTheme.textColor(context).withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ContributeDonateCard(
          imagePath: 'assets/images/contribute/patreon-logo.png',
          title: AppLocalizations.of(context)!.become_patreon,
          url: 'https://www.patreon.com/CircuitVerse',
        ),
        ContributeDonateCard(
          imagePath: 'assets/images/contribute/paypal-logo.jpg',
          title: AppLocalizations.of(context)!.donate_paypal,
          url: 'https://www.paypal.me/satviksr',
        ),
      ],
    );
  }
}
