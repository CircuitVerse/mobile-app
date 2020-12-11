import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';

class CVSubheader extends StatelessWidget {
  final String title;
  final String subtitle;

  const CVSubheader({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.w400,
                color: PrimaryAppTheme.getTextColor(context),
              ),
          textAlign: TextAlign.center,
        ),
        subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400,
                      color: PrimaryAppTheme.getTextColor(context),
                    ),
                textAlign: TextAlign.center,
              )
            : Container(),
      ],
    );
  }
}
