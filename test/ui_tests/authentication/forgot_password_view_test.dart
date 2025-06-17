import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/components/cv_password_field.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/forgot_password_view.dart';
import 'package:mobile_app/ui/views/authentication/login_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('LoginViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpLoginView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', '')],
          locale: const Locale('en', ''),
          home: const LoginView(),
        ),
      );

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic LoginView widgets', (WidgetTester tester) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Image && widget.height == 300,
        ),
        findsOneWidget,
      );

      expect(find.byType(CVTextField), findsOneWidget);
      expect(find.byType(CVPasswordField), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.byType(CVPrimaryButton), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) {
          return widget is RichText &&
              widget.text.toPlainText() == 'New User? Sign Up';
        }),
        findsOneWidget,
      );
    });

    testWidgets('ForgotPassword? onTap takes to ForgotPasswordView', (
      WidgetTester tester,
    ) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(ForgotPasswordView), findsOneWidget);
    });

    testWidgets('New User? Sign Up onTap takes to SignupView', (
      WidgetTester tester,
    ) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byWidgetPredicate((widget) {
          return widget is RichText &&
              widget.text.toPlainText() == 'New User? Sign Up';
        }),
      );
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(SignupView), findsOneWidget);
    });
  });
}
