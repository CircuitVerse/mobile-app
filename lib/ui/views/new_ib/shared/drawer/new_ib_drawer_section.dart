import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class NewIbDrawerSection extends StatelessWidget {
  final String title;

  const NewIbDrawerSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: IbTheme.textColor(context).withAlpha(128),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
