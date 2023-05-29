import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVOutlineButton extends StatelessWidget {
  const CVOutlineButton({
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color:
              isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor,
          width: 2,
        ),
      ),
      onPressed: onPressed ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: isBodyText
              ? Theme.of(context).textTheme.bodyLarge
              : Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
