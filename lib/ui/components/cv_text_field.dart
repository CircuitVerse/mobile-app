import 'package:flutter/material.dart';

class CVTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final IconData iconData;
  final int maxLines;
  final String initialValue;
  final Function(String) validator;
  final Function(String) onSaved;
  final bool isOutlined;
  final EdgeInsets padding;

  /// Creates a [TextField] that is specifically styled for CircuitVerse.
  ///
  /// When a [TextInputType] is not specified, it defaults to [TextInputType.text]
  /// `iconData` is the leading icon for the [TextField]
  const CVTextField({
    Key key,
    @required this.label,
    this.controller,
    this.type = TextInputType.text,
    this.iconData,
    this.maxLines = 1,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.isOutlined = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: type,
        initialValue: initialValue,
        style: TextStyle(color: Colors.black),
        decoration: isOutlined
            ? InputDecoration(
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                hintText: label,
              )
            : InputDecoration(
                labelText: label,
                labelStyle: Theme.of(context).textTheme.subtitle1,
                icon: iconData != null
                    ? Icon(
                        iconData,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      )
                    : null,
              ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
