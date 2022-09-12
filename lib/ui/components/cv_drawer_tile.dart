import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVDrawerTile extends StatelessWidget {
  const CVDrawerTile({
    required this.title,
    this.iconData,
    this.color,
    this.pending = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final IconData? iconData;
  final Color? color;
  final bool pending;

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
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontFamily: 'Poppins',
                color: color ?? CVTheme.textColor(context),
              ),
        ),
        trailing: Visibility(
          visible: pending,
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CVTheme.red,
            ),
          ),
        ),
      ),
    );
  }
}
