import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  static const String id = "home_view";

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      builder: (context, model, child) => Scaffold(),
    );
  }
}
