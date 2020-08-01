import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';

class CVPasswordField extends StatefulWidget {
  final Function(String) validator;
  final Function(String) onSaved;

  const CVPasswordField({Key key, this.validator, this.onSaved})
      : super(key: key);

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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        maxLines: 1,
        obscureText: _obscureText,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            child: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppTheme.primaryColor,
            ),
            onTap: _toggle,
          ),
          labelText: 'Password',
          labelStyle: Theme.of(context).textTheme.subtitle1,
        ),
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
