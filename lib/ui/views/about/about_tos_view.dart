import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/views/about/about_privacy_policy_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutTosView extends StatelessWidget {
  static const String id = 'about_tos_view';

  final bool showAppBar;

  const AboutTosView({Key key, this.showAppBar = true}) : super(key: key);

  TextSpan _buildText(BuildContext context, String text, {bool bold = false}) {
    return TextSpan(
      style: Theme.of(context).textTheme.bodyText1.copyWith(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Poppins',
          ),
      text: text,
    );
  }

  TextSpan _buildLink(String text, String link, {bool route = false}) {
    return TextSpan(
      style: TextStyle(
        color: Colors.blue,
        fontFamily: 'Poppins',
      ),
      text: text,
      recognizer: TapGestureRecognizer()
        ..onTap = !route
            ? () async {
                final url = link;
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: false,
                  );
                }
              }
            : () => Get.toNamed(link),
    );
  }

  Widget _buildSection({
    @required BuildContext context,
    @required String title,
    @required List<TextSpan> content,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
            textAlign: TextAlign.left,
          ),
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
      appBar: showAppBar ? AppBar(title: Text('Terms of Service')) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            _buildSection(
              context: context,
              title: '1. User Agreement',
              content: <TextSpan>[
                _buildText(
                  context,
                  '1.1 These Terms of Use constitute an agreement between you and the CircuitVerse Team that governs your use of ',
                ),
                _buildLink(
                  'CircuitVerse.org',
                  'https://circuitverse.org/',
                ),
                _buildText(
                  context,
                  '. The CircuitVerse Team comprises of faculty and students of International Institute of Information Technology, Bangalore ("IIIT-Bangalore"). Please read the Terms of Use carefully. By using CircuitVerse you affirm that you have read, understood, and accepted the terms and conditions in the Terms of Use. If you do not agree with any of these conditions, please do not use CircuitVerse.\n\n',
                ),
                _buildText(
                  context,
                  '1.2 Your privacy is important to us. Please read our Privacy Policy, which identifies how the CircuitVerse Team uses, collects, and stores information it collects through the Services. By using CircuitVerse, you additionally agree that you are comfortable with CircuitVerse\'s Privacy Policy.\n\n',
                ),
                _buildText(
                  context,
                  '1.3 CircuitVerse is open to children and adults of all ages, and we ask that you keep this in mind when using the CircuitVerse services.\n\n',
                ),
                _buildText(
                  context,
                  '1.4 The CircuitVerse Team may change the Terms of Use from time to time. You can always find the latest version of the Terms of Use at ',
                ),
                _buildLink(
                  'https://CircuitVerse.org/tos',
                  'https://CircuitVerse.org/tos',
                ),
                _buildText(context,
                    '. Your continued use of the Services constitutes your acceptance of any changes to or revisions of the Terms of Use.\n')
              ],
            ),
            _buildSection(
              context: context,
              title: '2. Account Creation and Maintenance',
              content: <TextSpan>[
                _buildText(
                  context,
                  '2.1 In order to use some features of the Services, you will need to register with CircuitVerse and create an account. Creating an account is optional, but without an account, you will not be able to save or publish projects or comments on CircuitVerse. When registering for a personal account, you will be asked to provide certain personal information, such as your email address, gender, birth month and year, and country. Please see CircuitVerse\'s ',
                ),
                _buildLink(
                  'Privacy Policy',
                  AboutPrivacyPolicyView.id,
                  route: true,
                ),
                _buildText(context,
                    " for CircuitVerse's data retention and usage policies.\n\n"),
                _buildText(
                  context,
                  '2.2 You are responsible for keeping your password secret and your account secure. You are solely responsible for any use of your account, even if your account is used by another person. If any use of your account violates the Terms of Service, your account may be suspended or deleted.\n\n',
                ),
                _buildText(context,
                    "2.3 You may not use another person's CircuitVerse account without permission.\n\n"),
                _buildText(
                  context,
                  '2.4 If you have reason to believe that your account is no longer secure (for example, in the event of a loss, theft, or unauthorized disclosure of your password), promptly change your password. If you cannot access your account to change your password, notify us at ',
                ),
                _buildLink(
                  'support@CircuitVerse.org',
                  'mailto:support@CircuitVerse.org',
                ),
                _buildText(context, '.\n')
              ],
            ),
            _buildSection(
              context: context,
              title: '3. Rules of Usage',
              content: <TextSpan>[
                _buildText(
                  context,
                  '3.1 The CircuitVerse Team supports freedom of expression. However, CircuitVerse is intended for a wide audience, and some content is inappropriate for the CircuitVerse community. You may not use the CircuitVerse service in any way, that:\n\n',
                ),
                _buildText(
                  context,
                  '\t1. Posting content deliberately designed to crash the CircuitVerse website or editor;\n\n',
                ),
                _buildText(
                  context,
                  '\t2. Linking to pages containing viruses or malware;\n\n',
                ),
                _buildText(
                  context,
                  '\t3. Using administrator passwords or pretending to be an administrator;\n\n',
                ),
                _buildText(
                  context,
                  '\t4. Repeatedly posting the same material, or "spamming";\n\n',
                ),
                _buildText(context,
                    '\t5. Using alternate accounts or organizing voting groups to manipulate site statistics, such as purposely trying to get on the "What the Community is Loving/Remixing" rows of the front page.\n\n')
              ],
            ),
            _buildSection(
              context: context,
              title: '4. User-Generated Content and Licensing',
              content: <TextSpan>[
                _buildText(
                  context,
                  '4.1 For the purposes of the Terms of Use, "user-generated content" includes any projects, comments, forum posts, or links to third party websites that a user submits to CircuitVerse.\n\n',
                ),
                _buildText(
                  context,
                  '4.2 The CircuitVerse Team encourages everyone to foster creativity by freely sharing knowledge in any form. However, we also understand the need for individuals and companies to protect their intellectual property rights. You are responsible for making sure you have the necessary rights, licenses, or permission for any user-generated content you submit to CircuitVerse.\n\n',
                ),
                _buildText(
                  context,
                  '4.3 All user-generated content you submit to CircuitVerse is licensed to and through CircuitVerse under the ',
                ),
                _buildLink(
                  'Creative Commons Attribution-ShareAlike 2.0 license',
                  'https://creativecommons.org/licenses/by-sa/2.0/',
                ),
                _buildText(
                  context,
                  '. This allows others to view and fork your content. This license also allows the CircuitVerse Team to display, distribute, and reproduce your content on the CircuitVerse website, through social media channels, and elsewhere. If you do not want to license your content under this license, then do not share it on CircuitVerse.\n\n',
                ),
                _buildText(
                  context,
                  '4.4 In addition to reviewing reported user-generated content, the CircuitVerse Team reserves the right, but is not obligated, to monitor all uses of the CircuitVerse service. The CircuitVerse Team may edit, move, or delete any content that violates the Terms of Use or Community Guidelines, without notice.\n\n',
                ),
                _buildText(context,
                    '4.5 All user-generated content is provided as-is. The CircuitVerse Team makes no warranties about the accuracy or reliability of any user-generated content available through CircuitVerse and does not endorse CircuitVerse Day events or vet or verify information posted in connection with said events. The CircuitVerse Team does not endorse any views, opinions, or advice expressed in user-generated content. You agree to relieve the CircuitVerse Team of any and all liability arising from your user-generated content and from CircuitVerse Day events you may organize or host.\n\n')
              ],
            ),
            _buildSection(
              context: context,
              title: '5. CircuitVerse Content and Licensing',
              content: <TextSpan>[
                _buildText(
                  context,
                  '5.1 Except for any user-generated content, the CircuitVerse Team owns and retains all rights in and to the CircuitVerse code, the design, functionality, and architecture of CircuitVerse, and any software or content provided through CircuitVerse (collectively "the CircuitVerse IP"). If you want to use CircuitVerse in a way that is not allowed by these Terms of Use, you must first contact the CircuitVerse Team. Except for any rights explicitly granted under these Terms of Use, you are not granted any rights in and to any CircuitVerse IP.\n\n',
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: '6. Digital Millennium Copyright Act (DMCA)',
              content: <TextSpan>[
                _buildText(
                  context,
                  '6.1 If you are a copyright holder and believe that content on CircuitVerse violates your rights, you may send a mail to ',
                ),
                _buildLink(
                  'support@CircuitVerse.org',
                  'mailto:support@CircuitVerse.org',
                ),
                _buildText(
                  context,
                  '.\n\n6.2 If you are a CircuitVerse user and you believe that your content did not constitute a copyright violation and was taken down in error, you may send a notification to support@CircuitVerse.org. Please include:\n\n',
                ),
                _buildText(
                  context,
                  '\t• Your CircuitVerse username and email address;\n\n',
                ),
                _buildText(
                  context,
                  '\t• The specific content you believe was taken down in error; and\n\n',
                ),
                _buildText(
                  context,
                  '\t• A brief statement of why you believe there was no copyright violation (e.g., the content was not copyrighted, you had permission to use the content, or your use of the content was a "fair use").\n\n',
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: '7. Suspension and Termination of Accounts',
              content: <TextSpan>[
                _buildText(
                  context,
                  '7.1 CircuitVerse has the right to suspend your account for violations of the Terms of Use or Community Guidelines. Repeat violators may have their account deleted. The CircuitVerse Team reserves the sole right to determine what constitutes a violation of the Terms of Use or Community Guidelines. The CircuitVerse Team also reserves the right to terminate any account used to circumvent prior enforcement of the Terms of Use.\n\n',
                ),
                _buildText(
                  context,
                  '7.2 If you want to delete or temporarily disable your account, please email ',
                ),
                _buildLink(
                  'support@CircuitVerse.org',
                  'mailto:support@CircuitVerse.org',
                ),
                _buildText(
                  context,
                  '.\n\n',
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: '8. Third Party Websites',
              content: <TextSpan>[
                _buildText(
                  context,
                  '8.1 Content on CircuitVerse, including user-generated content, may include links to third-party websites. The CircuitVerse Team is not capable of reviewing or managing third-party websites, and assumes no responsibility for the privacy practices, content, or functionality of third party websites. You agree to relieve the CircuitVerse Team of any and all liability arising from third party websites.\n\n',
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: '9. Indemnification',
              content: <TextSpan>[
                _buildText(context,
                    "You agree to indemnify IIIT-Bangalore, the CircuitVerse Team, the CircuitVerse Foundation, and all their affiliates, employees, faculty members, fellows, students, agents, representatives, third party service providers, and members of their governing boards (all of which are \"CircuitVerse Entities\"), and to defend and hold each of them harmless, from any and all claims and liabilities (including attorneys' fees) arising out of or related to your breach of the Terms of Service or your use of CircuitVerse.\n\n"),
                _buildText(context,
                    'For federal government agencies, provisions in the Terms of Use relating to Indemnification shall not apply to your Official Use, except to the extent expressly authorized by federal law. For state and local government agencies in the United States, Terms of Use relating to Indemnification shall apply to your Official Use only to the extent authorized by the laws of your jurisdiction.\n\n')
              ],
            ),
            _buildSection(
              context: context,
              title: '10. Disclaimer of Warranty',
              content: <TextSpan>[
                _buildText(context,
                    'You acknowledge that you are using CircuitVerse at your own risk. CircuitVerse is provided "as is," and the CircuitVerse Entities hereby expressly disclaim any and all warranties, express and implied, including but not limited to any warranties of accuracy, reliability, title, merchantability, non-infringement, fitness for a particular purpose or any other warranty, condition, guarantee or representation, whether oral, in writing or in electronic form, including but not limited to the accuracy or completeness of any information contained therein or provided by CircuitVerse. Without limiting the foregoing, the CircuitVerse Entities disclaim any and all warranties, express and implied, regarding user-generated content and CircuitVerse Day events. The CircuitVerse Entities and their third party service providers do not represent or warrant that access to CircuitVerse will be uninterrupted or that there will be no failures, errors or omissions or loss of transmitted information, or that no viruses will be transmitted through CircuitVerse services.\n\n',
                    bold: true),
              ],
            ),
            _buildSection(
              context: context,
              title: '11. Limitation of Liability',
              content: <TextSpan>[
                _buildText(context,
                    'The CircuitVerse Entities shall not be liable to you or any third parties for any direct, indirect, special, consequential or punitive damages of any kind, regardless of the type of claim or the nature of the cause of action, even if the CircuitVerse Team has been advised of the possibility of such damages. Without limiting the foregoing, the CircuitVerse Entities shall have no liability to you or any third parties for damages or harms arising out of user-generated content or CircuitVerse Day events.\n\n',
                    bold: true),
              ],
            ),
            _buildSection(
              context: context,
              title: '12. Choice of Language',
              content: <TextSpan>[
                _buildText(
                  context,
                  'If the CircuitVerse Team provides you with a translation of the English language version of these Terms of Use, the Privacy Policy, or any other policy, then you agree that the translation is provided for informational purposes only and does not modify the English language version. In the event of a conflict between a translation and the English version, the English version will govern.\n\n',
                ),
              ],
            ),
            _buildSection(
              context: context,
              title: '13. No Waiver',
              content: <TextSpan>[
                _buildText(
                  context,
                  'No waiver of any term of these Terms of Use shall be deemed a further or continuing waiver of such term or any other term, and the CircuitVerse Team\'s failure to assert any right or provision under these Terms of Use shall not constitute a waiver of such right or provision.\n\n',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
