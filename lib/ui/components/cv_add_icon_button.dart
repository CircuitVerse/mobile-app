import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVAddIconButton extends StatelessWidget {
  const CVAddIconButton({this.onPressed, Key? key}) : super(key: key);
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      icon: const Icon(
        Icons.add_circle_outline,
        color: CVTheme.grey,
        size: 36,
      ),
      onPressed: onPressed,
    );
  }
}
