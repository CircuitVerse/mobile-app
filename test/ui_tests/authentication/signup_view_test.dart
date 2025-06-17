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

import '../../setup/test_helpers.dart';
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
          supportedLocales: const [
            Locale('en', ''),
          ],
          locale: const Locale('en', ''),
          home: const LoginView(),
        ),
      );

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic LoginView widgets', (WidgetTester tester) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      final localizations = AppLocalizations.of(context)!;

      expect(
        find.byWidgetPredicate(
          (Widget widget) => widget is Image && widget.height == 300,
        ),
        findsOneWidget,
      );

      expect(find.byType(CVTextField), findsOneWidget);
      expect(find.byType(CVPasswordField), findsOneWidget);
      expect(find.text(localizations.forgot_password), findsOneWidget);
      expect(find.byType(CVPrimaryButton), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) {
          return widget is RichText &&
              widget.text.toPlainText() == '${localizations.new_user} ${localizations.sign_up}';
        }),
        findsOneWidget,
      );
    });

    testWidgets('ForgotPassword? onTap takes to ForgotPasswordView', (
      WidgetTester tester,
    ) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      final localizations = AppLocalizations.of(context)!;

      await tester.tap(find.text(localizations.forgot_password));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(ForgotPasswordView), findsOneWidget);
    });

    testWidgets('New User? Sign Up onTap takes to SignupView', (
      WidgetTester tester,
    ) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(LoginView));
      final localizations = AppLocalizations.of(context)!;

      await tester.tap(
        find.byWidgetPredicate((widget) {
          return widget is RichText &&
              widget.text.toPlainText() == '${localizations.new_user} ${localizations.sign_up}';
        }),
      );
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(SignupView), findsOneWidget);
    });

    testWidgets(
      'When email/password is not valid or empty, proper error message should be shown',
      (WidgetTester tester) async {
        var _usersApiMock = getAndRegisterUsersApiMock();

        await _pumpLoginView(tester);
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(LoginView));
        final localizations = AppLocalizations.of(context)!;

        await tester.tap(find.byType(CVPrimaryButton));
        await tester.pumpAndSettle();

        verifyNever(_usersApiMock.login('', ''));
        expect(find.text(localizations.email_validation_error), findsOneWidget);
        expect(find.text(localizations.password_validation_error), findsOneWidget);

        await tester.enterText(find.byType(CVTextField), 'test@test.com');
        await tester.tap(find.byType(CVPrimaryButton));
        await tester.pumpAndSettle();

        verifyNever(_usersApiMock.login('test@test.com', ''));
        expect(find.text(localizations.password_validation_error), findsOneWidget);
      },
    );
  });
}