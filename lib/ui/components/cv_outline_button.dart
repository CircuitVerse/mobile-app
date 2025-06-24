import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVOutlineButton extends StatelessWidget {
  const CVOutlineButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.leadingIcon,
    this.minWidth = 160,
    this.maxWidth = double.infinity,
    this.padding = const EdgeInsetsDirectional.symmetric(
      horizontal: 12,
      vertical: 10,
    ),
    this.fontSize,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final IconData? leadingIcon;
  final double minWidth;
  final double maxWidth;
  final EdgeInsetsDirectional padding;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: BorderSide(
            color:
                isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor,
            width: 2,
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(leadingIcon, size: 18),
              ),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: (isBodyText
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.titleLarge)
                    ?.copyWith(fontSize: fontSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
