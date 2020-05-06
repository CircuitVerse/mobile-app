import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/managers/dialog_manager.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/utils/styles.dart';

import 'ui/views/startup_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all the models and services before the app starts
  await setupLocator();

  runApp(CircuitVerseMobile());
}

class CircuitVerseMobile extends StatelessWidget {
  // This widget is the root of CircuitVerse Mobile.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CircuitVerse Mobile',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => DialogManager(child: child),
        ),
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: Router.generateRoute,
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Color.fromRGBO(66, 185, 131, 1)),
        fontFamily: 'Poppins',
        cursorColor: Color.fromRGBO(66, 185, 131, 1),
      ),
      home: StartUpView(),
    );
  }
}
