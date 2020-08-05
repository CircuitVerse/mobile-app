import 'package:flutter/material.dart';

class Validators {
  static final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool isEmailValid(String email) => _emailRegExp.hasMatch(email);

  static bool areEmailsValid(String emails) {
    // Get list of emails from controller..
    List _emails = emails.replaceAll(' ', '').split(',');

    // returns true if no email from above list voilates _emailRegExp..
    return _emails.where((email) => !_emailRegExp.hasMatch(email)).isEmpty;
  }

  static bool validateAndSaveForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
