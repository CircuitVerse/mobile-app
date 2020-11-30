import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';

class CVTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final TextInputAction action;
  final int maxLines;
  final String initialValue;
  final Function(String) validator;
  final Function(String) onSaved;
  final Function(String) fieldSubmitted;
  final EdgeInsets padding;
  final FocusNode focus_node;

  /// Creates a [TextField] that is specifically styled for CircuitVerse.
  ///
  /// When a [TextInputType] is not specified, it defaults to [TextInputType.text]
  ///
  /// When `maxLines` is not specified, it defaults to 1
  const CVTextField({
    Key key,
    @required this.label,
    this.controller,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.maxLines = 1,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    this.focus_node,
    this.fieldSubmitted,
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
        decoration: AppTheme.textFieldDecoration.copyWith(
          labelText: label,
        ),
        validator: validator,
        onSaved: onSaved,
        focusNode: focus_node,
        textInputAction: action,
        autofocus: true,
        onFieldSubmitted: fieldSubmitted,
      ),
    );
  }
}
