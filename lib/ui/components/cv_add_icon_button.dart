import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';

class CVAddIconButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CVAddIconButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      icon: Icon(
        Icons.add_circle_outline,
        color: PrimaryAppTheme.grey,
        size: 36,
      ),
      onPressed: onPressed,
    );
  }
}
