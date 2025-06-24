import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVPrimaryButton extends StatelessWidget {
  const CVPrimaryButton({
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.padding = const EdgeInsetsDirectional.all(8),
    this.textStyle,
    super.key,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  // Small button variant constructor
  factory CVPrimaryButton.small({
    required String title,
    VoidCallback? onPressed,
    bool isPrimaryDark = false,
  }) {
    return CVPrimaryButton(
      title: title,
      onPressed: onPressed,
      isPrimaryDark: isPrimaryDark,
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 6,
        horizontal: 12,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

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
        style:
            textStyle ??
            (isBodyText
                ? Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white)
                : Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}
