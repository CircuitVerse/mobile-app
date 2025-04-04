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
    this.minWidth = 88.0,
    super.key,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: 48),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor:
              isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
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
          ),
        ),
      ),
    );
  }
}
