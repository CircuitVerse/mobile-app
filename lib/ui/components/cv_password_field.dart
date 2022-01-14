import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVPasswordField extends StatefulWidget {
  const CVPasswordField({
    Key? key,
    this.validator,
    this.onSaved,
    this.focusNode,
  }) : super(key: key);

  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final FocusNode? focusNode;

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
        style: TextStyle(
          color: CVTheme.textColor(context),
        ),
        decoration: CVTheme.textFieldDecoration.copyWith(
          suffixIcon: GestureDetector(
            onTap: _toggle,
            child: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: CVTheme.primaryColorDark,
            ),
          ),
          labelText: 'Password',
          labelStyle: TextStyle(
            color: CVTheme.textFieldLabelColor(context),
          ),
        ),
        textInputAction: TextInputAction.done,
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
