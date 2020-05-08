import 'package:flutter/material.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/ui/views/login/login_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginView.id:
        return MaterialPageRoute(builder: (_) => LoginView());
      case HomeView.id:
        return MaterialPageRoute(builder: (_) => HomeView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
