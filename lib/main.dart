import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/locale/locales.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/managers/dialog_manager.dart';
import 'package:mobile_app/services/dialog_service.dart';
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
    return GetMaterialApp(
      title: 'CircuitVerse Mobile',
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context).title,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Navigator(
        key: locator<DialogService>().dialogNavigationKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => DialogManager(child: child),
        ),
      ),
      onGenerateRoute: Router.generateRoute,
      theme: ThemeData(
        primarySwatch: generateMaterialColor(AppTheme.primaryColor),
        fontFamily: 'Poppins',
        cursorColor: AppTheme.primaryColor,
      ),
      home: StartUpView(),
    );
  }
}
