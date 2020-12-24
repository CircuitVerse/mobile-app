import 'package:flutter/material.dart';

class CVStateFulButton extends StatefulWidget {
  CVStateFulButton(
      {@required this.triggerFunction,
      @required this.buttonText,
      this.context,
      @required Key key})
      : super(key: key);
  final Function triggerFunction;
  final String buttonText;
  final BuildContext context;
  @override
  CVStateFulButtonState createState() => CVStateFulButtonState();
}

class CVStateFulButtonState extends State<CVStateFulButton> {
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
