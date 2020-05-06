import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/startup_viewmodel.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<StartUpViewModel>(
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: Text(
            'CircuitVerse',
            style: Theme.of(context).textTheme.display2.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
