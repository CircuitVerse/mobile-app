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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('LoginViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpLoginView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: Locale('en'),
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: LoginView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic LoginView widgets', (WidgetTester tester) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      var _loginImagePredicate =
          (Widget widget) => widget is Image && widget.height == 300;

      expect(find.byWidgetPredicate(_loginImagePredicate), findsOneWidget);
      expect(find.byType(CVTextField), findsOneWidget);
      expect(find.byType(CVPasswordField), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.byType(CVPrimaryButton), findsOneWidget);
      expect(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == 'New User? Sign Up';
      }), findsOneWidget);
    });

    testWidgets('ForgotPassword? onTap takes to ForgotPasswordView',
        (WidgetTester tester) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(ForgotPasswordView), findsOneWidget);
    });

    testWidgets('New User? Sign Up onTap takes to SignupView',
        (WidgetTester tester) async {
      await _pumpLoginView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == 'New User? Sign Up';
      }));
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

      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.login('', ''));
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password can\'t be empty'), findsOneWidget);

      await tester.enterText(find.byType(CVTextField), 'test@test.com');
      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.login('test@test.com', ''));
      expect(find.text('Password can\'t be empty'), findsOneWidget);
    });
  });
}
