import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVHeader extends StatelessWidget {
  const CVHeader({
    required this.title,
    this.subtitle,
    this.description,
    this.titleToSubtitleSpace = 0,
    this.subtitleToDescriptionSpace = 16,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final double titleToSubtitleSpace;
  final double subtitleToDescriptionSpace;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: CVTheme.primaryColorDark,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: titleToSubtitleSpace),
        if (subtitle != null)
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: CVTheme.textColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        SizedBox(height: subtitleToDescriptionSpace),
        if (description != null)
          Text(
            description!,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
