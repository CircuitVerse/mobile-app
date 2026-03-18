import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVDrawerTile extends StatelessWidget {
  const CVDrawerTile({
    required this.title,
    this.iconData,
    this.color,
    this.pending = false,
    this.isActive = false,
    this.isChild = false,
    super.key,
  });

  final String title;
  final IconData? iconData;
  final Color? color;
  final bool pending;
  final bool isActive;
  final bool isChild;

  @override
  Widget build(BuildContext context) {
    final activeColor = CVTheme.primaryColor;
    final effectiveColor =
        isActive ? activeColor : (color ?? CVTheme.drawerIcon(context));

    return Container(
      margin: const EdgeInsetsDirectional.only(
        start: 8,
        end: 8,
        top: 2,
        bottom: 2,
      ),
      decoration: BoxDecoration(
        color: isActive ? CVTheme.primaryColor.withOpacity(0.12) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: CVTheme.themeData(context),
        child: ListTile(
          contentPadding: EdgeInsetsDirectional.only(
            start: isChild ? 56 : 16,
            end: 16,
            top: 0,
            bottom: 0,
          ),
          minLeadingWidth: 24,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: !isChild && iconData != null
              ? Icon(
                  iconData,
                  color: effectiveColor,
                  size: 24,
                )
              : null,
          title: Row(
            children: [
              if (isChild && iconData != null) ...[
                Icon(
                  iconData,
                  color: effectiveColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Poppins',
                    fontSize: isChild ? 15 : 16,
                    color: isActive
                        ? activeColor
                        : (color ?? CVTheme.textColor(context)),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
          trailing: pending
              ? Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CVTheme.red,
                    boxShadow: [
                      BoxShadow(
                        color: CVTheme.red.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
