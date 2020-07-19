import 'package:flutter/material.dart';

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
    this.isPrimaryDark = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: isBodyText
              ? Theme.of(context).textTheme.bodyText1
              : Theme.of(context).textTheme.headline6,
        ),
      ),
      borderSide: BorderSide(
        color: isPrimaryDark
            ? Theme.of(context).primaryColorDark
            : Theme.of(context).primaryColor,
        width: 2,
      ),
      onPressed: onPressed ?? () {},
    );
  }
}
