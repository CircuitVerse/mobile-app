import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:theme_provider/theme_provider.dart';

class CVPasswordField extends StatefulWidget {
  final Function(String) validator;
  final Function(String) onSaved;
  final FocusNode focusNode;

  const CVPasswordField({
    Key key,
    this.validator,
    this.onSaved,
    this.focusNode,
  }) : super(key: key);

  @override
  _CVPasswordFieldState createState() => _CVPasswordFieldState();
}

class _CVPasswordFieldState extends State<CVPasswordField> {
  bool _obscureText = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: TextFormField(
        focusNode: widget.focusNode,
        maxLines: 1,
        obscureText: _obscureText,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: PrimaryAppTheme.getTextColor(context)),
        decoration: PrimaryAppTheme.textFieldDecoration.copyWith(
            suffixIcon: GestureDetector(
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: PrimaryAppTheme.primaryColorDark,
              ),
              onTap: _toggle,
            ),
            labelText: 'Password',
            labelStyle:
                TextStyle(color: PrimaryAppTheme.textfieldlabelColor(context))),
        textInputAction: TextInputAction.done,
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
