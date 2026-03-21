import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/database_service.dart';
import 'package:mobile_app/services/notifications_service.dart';
import 'package:mobile_app/services/API/fcm_api.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:mobile_app/ui/views/startup_view.dart';
import 'package:mobile_app/controllers/language_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all the models and services before the app starts
  await setupLocator();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications
  await NotificationsServiceImpl.initializeLocalNotifications();

  // Init Hive
  await locator<DatabaseService>().init();
  Get.put(LanguageController());

  runApp(const CircuitVerseMobile());
}

class CircuitVerseMobile extends StatefulWidget {
  const CircuitVerseMobile({super.key});

  @override
  State<CircuitVerseMobile> createState() => _CircuitVerseMobileState();
}

class _CircuitVerseMobileState extends State<CircuitVerseMobile> {
  late FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();
    _messaging = FirebaseMessaging.instance;
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    // Request permission for iOS
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Get FCM token
      String? token = await _messaging.getToken();
      print('FCM Token: $token');
      
      // Send token to backend server
      if (token != null) {
        try {
          final fcmApi = HttpFCMApi();
          final response = await fcmApi.sendToken(token);
          print('FCM token sent to backend: $response');
        } catch (e) {
          print('Failed to send FCM token to backend: $e');
        }
      }
      
      // Handle foreground messages - show notification in tray
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification}');
        
        // Always show notification in phone tray when message arrives
        NotificationsServiceImpl.showNotification(message);
      });

      // Handle notification tap when app is in background but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        // TODO: Navigate to specific screen based on message data
      });

      // Check if app was opened from a terminated state via notification
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from terminated state via notification');
        // TODO: Navigate to specific screen based on message data
      }
    } else {
      print('User declined or has not accepted permission');
    }
  }



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
                (themeContext) => GetBuilder<LanguageController>(
                  builder: (languageController) {
                    final locale = languageController.currentLocale.value;

                    return GetMaterialApp(
                      title: 'CircuitVerse Mobile',
                      debugShowCheckedModeBanner: false,
                      locale: locale,
                      localizationsDelegates: delegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      onGenerateTitle:
                          (context) => AppLocalizations.of(context)!.cv_title,
                      theme: ThemeProvider.themeOf(
                        themeContext,
                      ).data.copyWith(platform: TargetPlatform.android),
                      onGenerateRoute: CVRouter.generateRoute,
                      home: const StartUpView(),
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
