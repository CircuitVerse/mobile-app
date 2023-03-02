import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/views/about/about_privacy_policy_view.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutTosView extends StatelessWidget {
  const AboutTosView({Key? key, this.showAppBar = true}) : super(key: key);

  static const String id = 'about_tos_view';

  final bool showAppBar;

  TextSpan _buildText(BuildContext context, String text, {bool bold = false}) {
    return TextSpan(
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Poppins',
          ),
      text: text,
    );
  }

  TextSpan _buildLink(String text, String link, {bool route = false}) {
    return TextSpan(
      style: const TextStyle(
        color: Colors.blue,
        fontFamily: 'Poppins',
      ),
      text: text,
      recognizer: TapGestureRecognizer()
        ..onTap = !route
            ? () async {
                final url = link;
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                }
              }
            : () => Get.toNamed(link),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<TextSpan> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: CVTheme.primaryHeading(context),
              ),
          textAlign: TextAlign.left,
        ),
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
                AppLocalizations.of(context)!.terms_of_service,
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
              title: AppLocalizations.of(context)!.tos_section1_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section1_text1_string1,
                ),
                _buildLink(
                  'CircuitVerse.org',
                  'https://circuitverse.org/',
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section1_text1_string2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section1_text2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section1_text3,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section1_text4_string1,
                ),
                _buildLink(
                  AppLocalizations.of(context)!.terms_of_service,
                  'https://CircuitVerse.org/tos',
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section1_text4_string2,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section2_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section2_text1_string1,
                ),
                _buildLink(
                  AppLocalizations.of(context)!.privacy_policy,
                  AboutPrivacyPolicyView.id,
                  route: true,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section2_text1_string2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section2_text2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section2_text3,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section2_text4,
                ),
                _buildLink(
                  'support@CircuitVerse.org',
                  'mailto:support@CircuitVerse.org',
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.full_stop,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section3_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section3_text1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section3_item1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section3_item2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section3_item3,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section3_item4,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section3_item5,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section4_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section4_text1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section4_text2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section4_text3_string1,
                ),
                _buildLink(
                  AppLocalizations.of(context)!.tos_section4_text3_link,
                  'https://creativecommons.org/licenses/by-sa/2.0/',
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section4_text3_string2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section4_text4,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section4_text5,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section5_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section5_text1,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section6_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section6_text1,
                ),
                _buildLink(
                  'support@CircuitVerse.org',
                  'mailto:support@CircuitVerse.org',
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section6_text2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section6_item1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section6_item2,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section6_item3,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section7_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section7_text1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section7_text2,
                ),
                _buildLink(
                  'support@CircuitVerse.org',
                  'mailto:support@CircuitVerse.org',
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.full_stop,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section8_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section8_text1,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section9_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section9_text1,
                ),
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section9_text2,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section10_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section10_text1,
                  bold: true,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section11_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section11_text1,
                  bold: true,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section12_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section12_text1,
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: AppLocalizations.of(context)!.tos_section13_title,
              content: <TextSpan>[
                _buildText(
                  context,
                  AppLocalizations.of(context)!.tos_section13_text1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
