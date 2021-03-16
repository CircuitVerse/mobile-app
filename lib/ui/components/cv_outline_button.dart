import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVOutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;

  const CVOutlineButton({
    Key key,
    @required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
  }) : super(key: key);

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
              ? Theme.of(context).textTheme.bodyText1
              : Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
