import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVSubheader extends StatelessWidget {
  const CVSubheader({Key key, this.title, this.subtitle}) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.w400,
                color: CVTheme.textColor(context),
              ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w400,
                  color: CVTheme.textColor(context),
                ),
            textAlign: TextAlign.center,
          )
        else
          Container(),
      ],
    );
  }
}
