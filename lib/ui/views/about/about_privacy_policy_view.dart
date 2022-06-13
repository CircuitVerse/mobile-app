import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPrivacyPolicyView extends StatelessWidget {
  const AboutPrivacyPolicyView({Key? key, this.showAppBar = true})
      : super(key: key);

  static const String id = 'about_privacy_policy_view';

  final bool showAppBar;

  TextSpan _buildText(BuildContext context, String text,
      {bool bold = false, bool italic = false}) {
    return TextSpan(
      style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            fontFamily: 'Poppins',
          ),
      text: text,
    );
  }

  TextSpan _buildLink(String text, String link, {bool italic = false}) {
    return TextSpan(
      style: TextStyle(
        color: Colors.blue,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: 'Poppins',
      ),
      text: text,
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          final url = link;
          if (await canLaunchUrlString(url)) {
            await launchUrlString(url);
          }
        },
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required List<TextSpan> content,
    String title = '',
    bool heading = false,
  }) {
    var style = heading
        ? Theme.of(context).textTheme.headline5
        : Theme.of(context).textTheme.headline6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != '')
          Text(
            title,
            style: style?.copyWith(
              fontWeight: FontWeight.w400,
              color: CVTheme.primaryHeading(context),
            ),
            textAlign: TextAlign.left,
          )
        else
          Container(),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            children: content,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(
                AppLocalizations.of(context)!.privacy_policy,
                style: TextStyle(
                  color: CVTheme.primaryHeading(context),
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildSection(
              context: context,
              content: [
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section1_text,
                ),
                _buildLink(
                  AppLocalizations.of(context)!.terms_of_service,
                  'https://circuitverse.org/tos',
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.full_stop,
                ),
              ],
            ),
            _buildSection(
              title: AppLocalizations.of(context)!.privacy_section_2_title,
              context: context,
              content: [
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_text,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_item1,
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_item1_text,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_item2,
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_item2_text,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_item3,
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section2_item3_text,
                ),
              ],
            ),
            _buildSection(
              title: AppLocalizations.of(context)!.privacy_section3_title,
              context: context,
              content: [
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_list_header,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_item1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_item2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_item3,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_item4,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_item5,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_item6,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text2_title,
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text3_title,
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text3,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text4_title,
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text4_string1,
                ),
                _buildLink(
                  AppLocalizations.of(context)!.google_analytics,
                  'https://support.google.com/analytics/answer/6004245?hl=en',
                  italic: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.privacy_section3_text4_string2,
                )
              ],
            ),
            _buildSection(
              title: AppLocalizations.of(context)!.contact_us,
              context: context,
              content: [
                _buildText(
                  context,
                  AppLocalizations.of(context)!.contact_us_text,
                ),
                _buildLink('support@circuitverse.org',
                    'mailto:privacy@CircuitVerse.com',
                    italic: true),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.full_stop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
