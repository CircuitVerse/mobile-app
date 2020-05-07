import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  static const String id = "login_view";

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      builder: (context, model, child) => Scaffold(),
    );
  }
}
