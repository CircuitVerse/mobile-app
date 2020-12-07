import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

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
                color: ThemeProvider.themeOf(context).id == 'dark'
                    ? Colors.white
                    : Colors.black,
              ),
          textAlign: TextAlign.center,
        ),
        subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w400,
                      color: ThemeProvider.themeOf(context).id == 'dark'
                          ? Colors.white
                          : Colors.black,
                    ),
                textAlign: TextAlign.center,
              )
            : Container(),
      ],
    );
  }
}
