import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVFlatButton extends StatefulWidget {
  const CVFlatButton({
    required Key key,
    required this.triggerFunction,
    required this.buttonText,
    this.context,
  }) : super(key: key);
  final Function triggerFunction;
  final String buttonText;
  final BuildContext? context;
  @override
  CVFlatButtonState createState() => CVFlatButtonState();
}

class CVFlatButtonState extends State<CVFlatButton> {
  Function? dynamicFunction;
  bool isButtonActive = false;
  void setDynamicFunction(bool isActive) {
    setState(() {
      dynamicFunction = isActive ? widget.triggerFunction : null;
      isButtonActive = isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: isButtonActive
            ? MaterialStateProperty.all(CVTheme.primaryColor)
            : MaterialStateProperty.all(Colors.grey),
      ),
      onPressed: dynamicFunction == null
          ? null
          : () => dynamicFunction!.call(widget.context),
      child: Text(widget.buttonText),
    );
  }
}
