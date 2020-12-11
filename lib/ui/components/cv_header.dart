import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';

class CVHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;

  const CVHeader(
      {Key key, @required this.title, this.subtitle, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline3.copyWith(
                fontWeight: FontWeight.w400,
                color: PrimaryAppTheme.primaryColorDark,
              ),
          textAlign: TextAlign.center,
        ),
        subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PrimaryAppTheme.getTextColor(context),
                    ),
                textAlign: TextAlign.center,
              )
            : Container(),
        description != null
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
      ],
    );
  }
}
