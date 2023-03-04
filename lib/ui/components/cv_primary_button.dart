import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVPrimaryButton extends StatelessWidget {
  const CVPrimaryButton({
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.padding = const EdgeInsets.all(8),
    Key? key,
  }) : super(key: key);

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        backgroundColor:
            isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor,
      ),
      onPressed: onPressed ?? () {},
      child: Text(
        title,
        style: isBodyText
            ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                )
            : Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
      ),
    );
  }
}
