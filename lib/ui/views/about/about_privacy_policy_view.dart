import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPrivacyPolicyView extends StatelessWidget {
  static const String id = 'about_privacy_policy_view';

  final bool showAppBar;

  const AboutPrivacyPolicyView({Key key, this.showAppBar = true})
      : super(key: key);

  TextSpan _buildText(BuildContext context, String text,
      {bool bold = false, bool italic = false}) {
    return TextSpan(
      style: Theme.of(context).textTheme.bodyText1.copyWith(
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
          if (await canLaunch(url)) {
            await launch(
              url,
              forceSafariVC: false,
            );
          }
        },
    );
  }

  Widget _buildSection({
    @required BuildContext context,
    String title = '',
    bool heading = false,
    @required List<TextSpan> content,
  }) {
    var style = heading
        ? Theme.of(context).textTheme.headline5
        : Theme.of(context).textTheme.headline6;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title != ''
              ? Text(
                  title,
                  style: style.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.black),
                  textAlign: TextAlign.left,
                )
              : Container(),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              children: content,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: Text('Privacy Policy')) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildSection(
              context: context,
              content: [
                _buildText(
                  context,
                  '\nWe recognize that your privacy is very important and take it seriously. Our CircuitVerse Privacy Policy (“Privacy Policy”) describes our policies and procedures on the collection, use, disclosure, and sharing of your information when you use our Platform. We will not use or share your information with anyone except as described in this Privacy Policy. Capitalized terms that are not defined in this Privacy Policy have the meaning given them in our ',
                ),
                _buildLink(
                  'Terms of Service',
                  'https://circuitverse.org/tos',
                  italic: true,
                ),
                _buildText(
                  context,
                  '.\n',
                ),
              ],
            ),
            _buildSection(
              title: 'The Information We Collect',
              context: context,
              content: [
                _buildText(
                  context,
                  'We collect information directly from individuals automatically through the CircuitVerse Platform.\n\n',
                ),
                _buildText(
                  context,
                  'Account and Profile Information: ',
                  bold: true,
                  italic: true,
                ),
                _buildText(context,
                    'When you create an account and profile on the CircuitVerse Platform, we collect your email-id. Your name, photo, and any other information that you choose to add to your public-facing profile will be available for viewing to users of our Platform. Once you activate a profile, other users will be able to see in your profile certain information about your activity.\n\n'),
                _buildText(
                  context,
                  'Integrated Service Provider and Linked Networks. ',
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  'If you elect to connect your CircuitVerse account to another online service provider, such as a social networking service (“Integrated Service Provider”), you will be allowing us to pass to and receive from the Integrated Service Provider your log-in information and other user data. You may elect to sign in or sign up to the CircuitVerse Platform through a linked network like Facebook or Google (each a “Linked Network”).The specific information we may collect varies by Integrated Service Provider, but the permissions page for each will describe the relevant information. Integrated Service Providers control how they use and share your information; you should consult their respective privacy policies for information about their practices.\n\n',
                ),
                _buildText(
                  context,
                  'Automatically Collected Information About Your Activity. ',
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  'We use cookies, log files, pixel tags, local storage objects, and other tracking technologies to automatically collect information about your activities, such as your searches, page views, date and time of your visit, and other information about your use of the CircuitVerse Platform.\n\n',
                ),
              ],
            ),
            _buildSection(
              title: 'How We Use Your Information',
              context: context,
              content: [
                _buildText(
                  context,
                  'We do not sell your personally identifying information – such as your name and contact information – to third parties to use for their own marketing purposes.\n\n',
                ),
                _buildText(
                  context,
                  'CircuitVerse uses the information we collect:\n\n',
                ),
                _buildText(
                  context,
                  '\t• To provide you the services we offer on the CircuitVerse Platform, communicate with you about your use of the CircuitVerse Platform, respond to your inquiries, provide troubleshooting, and for other customer service purposes.\n\n',
                ),
                _buildText(
                  context,
                  '\t• To tailor the content and information that we may send or display to you in the CircuitVerse Platform.\n\n',
                ),
                _buildText(
                  context,
                  '\t• To better understand how users access and use the CircuitVerse Platform both on an aggregated and individualized basis, and for other research and analytical purposes.\n\n',
                ),
                _buildText(
                  context,
                  '\t• To evaluate and improve the CircuitVerse Platform and to develop new products and services.\n\n',
                ),
                _buildText(
                  context,
                  '\t• To comply with legal obligations, as part of our general business operations, and for other business administration purposes.\n\n',
                ),
                _buildText(
                  context,
                  '\t• Where we believe necessary to investigate, prevent or take action regarding illegal activities, suspected fraud, situations involving potential threats to the safety of any person or violations of our Terms of Use or this Privacy Policy.\n\n',
                ),
                _buildText(context, 'Your Content and Activity. ',
                    bold: true, italic: true),
                _buildText(
                  context,
                  'Your Content, including your name, profile picture, profile information, and certain associated activity information is available to other users of the CircuitVerse Platform and may be viewed publicly. Public viewing includes availability to non-registered visitors and can occur when users share Your Content across other sites or services. In addition, Your Content may be indexed by search engines.\n\n',
                ),
                _buildText(
                  context,
                  'Anonymized and Aggregated Data. ',
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  'We may share aggregate or de-identified information with third parties for research, marketing, analytics and other purposes, provided such information does not identify a particular individual.\n\n',
                ),
                _buildText(
                  context,
                  'Tracking. ',
                  bold: true,
                  italic: true,
                ),
                _buildText(
                  context,
                  'Analytics Tools -We may use internal and third party analytics tools, including ',
                ),
                _buildLink(
                  'Google Analytics',
                  'https://support.google.com/analytics/answer/6004245?hl=en',
                  italic: true,
                ),
                _buildText(
                  context,
                  '. The third party analytics companies we work with may combine the information collected with other information they have independently collected from other websites and/or other online products and services. Their collection and use of information is subject to their own privacy policies.\n\n',
                )
              ],
            ),
            _buildSection(
              title: 'Contact Us',
              context: context,
              content: [
                _buildText(
                  context,
                  'If you have any questions about our practices or this Privacy Policy, please contact us at ',
                ),
                _buildLink('support@circuitverse.org',
                    'mailto:privacy@CircuitVerse.com',
                    italic: true),
                _buildText(
                  context,
                  '.\n\n',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
