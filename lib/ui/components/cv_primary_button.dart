import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;
  final EdgeInsetsGeometry padding;

  const CVPrimaryButton({
    Key? key,
    required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
    this.padding = const EdgeInsets.all(8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        primary:
            isPrimaryDark ? CVTheme.primaryColorDark : CVTheme.primaryColor,
      ),
      onPressed: onPressed ?? () {},
      child: Text(
        title,
        style: isBodyText
            ? Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: Colors.white,
                )
            : Theme.of(context).textTheme.headline6!.copyWith(
                  color: Colors.white,
                ),
      ),
    );
  }
}
