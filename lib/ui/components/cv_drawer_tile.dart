import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVDrawerTile extends StatelessWidget {
  const CVDrawerTile({
    required this.title,
    this.iconData,
    this.color,
    this.pending = false,
    this.isActive = false,
    super.key,
  });

  final String title;
  final IconData? iconData;
  final Color? color;
  final bool pending;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final activeColor = CVTheme.primaryColor;
    final effectiveColor =
        isActive ? activeColor : (color ?? CVTheme.drawerIcon(context));

    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? CVTheme.primaryColor.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: CVTheme.themeData(context),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: iconData != null
              ? Icon(iconData, color: effectiveColor)
              : null,
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontFamily: 'Poppins',
              color: isActive
                  ? activeColor
                  : (color ?? CVTheme.textColor(context)),
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          trailing: pending
              ? Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: CVTheme.red,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
