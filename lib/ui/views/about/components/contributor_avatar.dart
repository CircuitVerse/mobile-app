import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/models/cv_contributors.dart';
import 'package:mobile_app/utils/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';

class ContributorAvatar extends StatelessWidget {
  final CircuitVerseContributor contributor;

  const ContributorAvatar({Key key, @required this.contributor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchURL(contributor.htmlUrl),
      child: Tooltip(
        message: contributor.login,
        child: Container(
          margin: const EdgeInsets.all(4),
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: PrimaryAppTheme.primaryColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: contributor.avatarUrl,
            ),
          ),
        ),
      ),
    );
  }
}
