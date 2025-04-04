import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVPrimaryButton extends StatelessWidget {
  const CVPrimaryButton({
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.textStyle,
    super.key,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        minimumSize: const Size.fromHeight(48), // Consistent height
        backgroundColor:
            isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Perfect rounded edges
        ),
        elevation: 0,
      ),
      onPressed: onPressed ?? () {},
      child: Text(
        title,
        style:
            textStyle ??
            (isBodyText
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                )
                : Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.white)),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
