import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/startup/startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<StartUpViewModel>(
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Center(
          child: Text(
            'CircuitVerse',
            style: Theme.of(context).textTheme.headline4.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
