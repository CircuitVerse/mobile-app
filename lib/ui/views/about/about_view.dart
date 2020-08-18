import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_social_card.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/about/components/contributor_avatar.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/about/about_viewmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutView extends StatefulWidget {
  static const String id = 'about_view';

  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _launchURL(String url, String title) async {
    await Get.to(
      Scaffold(
        appBar: AppBar(title: Text(title)),
        body: WebView(initialUrl: url),
      ),
      transition: Transition.cupertino,
    );
  }

  Widget _buildTosAndPrivacyButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        children: <Widget>[
          Expanded(
            child: CVPrimaryButton(
              title: 'Terms Of Service',
              isBodyText: true,
              onPressed: () => _launchURL(
                'https://circuitverse.org/tos',
                'Terms of Service',
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: CVPrimaryButton(
              title: 'Privacy Policy',
              isBodyText: true,
              onPressed: () => _launchURL(
                'https://circuitverse.org/privacy',
                'Privacy',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributorsList(AboutViewModel model) {
    switch (model.state) {
      case ViewState.Success:
        var _contributorsAvatars = <Widget>[];
        model.cvContributors.forEach((contributor) {
          if (contributor.type == Type.USER) {
            _contributorsAvatars.add(
              ContributorAvatar(contributor: contributor),
            );
          }
        });
        return Wrap(
          alignment: WrapAlignment.center,
          children: _contributorsAvatars,
        );
        break;
      case ViewState.Busy:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'Loading Contributors ...',
            textAlign: TextAlign.center,
          ),
        );
        break;
      case ViewState.Error:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            model.errorMessage,
            textAlign: TextAlign.center,
          ),
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseView<AboutViewModel>(
      onModelReady: (model) => model.fetchContributors(),
      builder: (context, model, child) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              CVHeader(
                title: 'ABOUT',
                subtitle: 'Learn about the Awesome people behind CircuitVerse',
                description:
                    'CircuitVerse is a product developed by students at IIIT-Bangalore. It aims to provide a platform where circuits can be designed and simulated using a graphical user interface. While users can design complete CPU implementations within the simulator, the software is designed primarily for educational use. CircuitVerse is an opensource project with an active community. Checkout the contribute page for more detail.',
              ),
              _buildTosAndPrivacyButtons(),
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
              Divider(),
              CVSubheader(
                title: 'Contributors',
                subtitle:
                    "Meet the awesome people of CircuitVerse community that've made this platform what it is now.",
              ),
              _buildContributorsList(model),
            ],
          ),
        ),
      ),
    );
  }
}
