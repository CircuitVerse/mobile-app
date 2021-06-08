import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVDrawerTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;

  const CVDrawerTile({Key key, @required this.title, this.iconData, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CVTheme.themeData(context),
      child: ListTile(
        leading: iconData != null
            ? Icon(
                iconData,
                color: color ?? CVTheme.drawerIcon(context),
              )
            : null,
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline6.copyWith(
                fontFamily: 'Poppins',
                color: color ?? CVTheme.textColor(context),
              ),
        ),
      ),
    );
  }
}
