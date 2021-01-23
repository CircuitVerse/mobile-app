import 'package:flutter/material.dart';

class CVFlatButton extends StatefulWidget {
  CVFlatButton({
    @required Key key,
    @required this.triggerFunction,
    @required this.buttonText,
    this.context,
  }) : super(key: key);
  final Function triggerFunction;
  final String buttonText;
  final BuildContext context;
  @override
  CVFlatButtonState createState() => CVFlatButtonState();
}

class CVFlatButtonState extends State<CVFlatButton> {
  Function dynamicFunction;
  void setDynamicFunction(bool isActive) {
    setState(() {
      dynamicFunction = isActive ? widget.triggerFunction : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text('${widget.buttonText}'),
      disabledTextColor: Colors.grey,
      onPressed: dynamicFunction == null
          ? null
          : () => dynamicFunction.call(widget.context),
    );
  }
}
