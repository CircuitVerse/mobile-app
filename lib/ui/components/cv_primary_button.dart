import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';

class CVPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isBodyText;
  final bool isPrimaryDark;

  const CVPrimaryButton({
    Key key,
    @required this.title,
    this.onPressed,
    this.isBodyText = false,
    this.isPrimaryDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: isBodyText
              ? Theme.of(context).textTheme.bodyText1.copyWith(
                    color: Colors.white,
                  )
              : Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.white,
                  ),
        ),
      ),
      color: isPrimaryDark ? AppTheme.primaryColorDark : AppTheme.primaryColor,
      onPressed: onPressed ?? () {},
    );
  }
}
