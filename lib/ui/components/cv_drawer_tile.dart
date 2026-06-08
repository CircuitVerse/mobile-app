import 'package:flutter/material.dart';

class CVDrawerTile extends StatelessWidget {
  const CVDrawerTile({
    required this.title,
    this.iconData,
    this.color,
    this.pending = false,
    super.key,
  });

  final String title;
  final IconData? iconData;
  final Color? color;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          iconData != null
              ? Badge(
                isLabelVisible: pending,
                child: Icon(iconData, color: color),
              )
              : null,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
