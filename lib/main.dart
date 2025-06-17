import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/database_service.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:mobile_app/ui/views/startup_view.dart';
import 'package:mobile_app/controllers/language_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all the models and services before the app starts
  await setupLocator();

  // Init Hive
  await locator<DatabaseService>().init();
  Get.put(LanguageController());

  runApp(const CircuitVerseMobile());
}

class CircuitVerseMobile extends StatelessWidget {
  const CircuitVerseMobile({super.key});

  // This widget is the root of CircuitVerse Mobile.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var delegates = AppLocalizations.localizationsDelegates.toList();
    delegates.add(FlutterQuillLocalizations.delegate);

    return KeyboardDismissOnTap(
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: [
          AppTheme(
            id: 'light',
            data: ThemeData(
              fontFamily: 'Poppins',
              brightness: Brightness.light,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: CVTheme.primaryColor,
              ),
              appBarTheme: AppBarTheme(
                foregroundColor: CVTheme.drawerIcon(context),
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: CVTheme.primaryColor,
                brightness: Brightness.light,
              ),
            ),
            description: 'LightTheme',
          ),
          AppTheme(
            id: 'dark',
            data: ThemeData(
              fontFamily: 'Poppins',
              brightness: Brightness.dark,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: CVTheme.primaryColor,
              ),
            ),
            description: 'DarkTheme',
          ),
        ],
        child: ThemeConsumer(
          child: Builder(
            builder:
                (themeContext) => GetMaterialApp(
                  title: 'CircuitVerse Mobile',
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: delegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  onGenerateTitle:
                      (context) => AppLocalizations.of(context)!.title,
                  theme: ThemeProvider.themeOf(themeContext).data,
                  onGenerateRoute: CVRouter.generateRoute,
                  home: const StartUpView(),
                ),
          ),
        ),
      ),
    );
  }
}
