import 'package:flutter/material.dart';

class CVTabBar extends StatelessWidget implements PreferredSizeWidget {
  final Color color;
  final TabBar tabBar;

  CVTabBar({this.color, this.tabBar});

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4),
        ),
      ),
      child: tabBar,
    );
  }
}
