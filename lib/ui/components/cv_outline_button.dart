import 'package:flutter/material.dart';

class CVOutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CVOutlineButton({Key key, this.title, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: Text(title),
      borderSide: BorderSide(
        color: Theme.of(context).primaryColorDark,
        width: 2,
      ),
      onPressed: onPressed ?? () {},
    );
  }
}
