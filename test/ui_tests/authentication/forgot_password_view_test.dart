import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/forgot_password_view.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_helpers.dart';
import '../../setup/test_helpers.mocks.dart';

void main() {
  group('ForgotPasswordViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpForgotPasswordView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const ForgotPasswordView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic ForgotPasswordView widgets',
        (WidgetTester tester) async {
      await _pumpForgotPasswordView(tester);
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
              (Widget widget) => widget is Image && widget.height == 300),
          findsOneWidget);
      expect(find.byType(CVTextField), findsOneWidget);
      expect(find.byType(CVPrimaryButton), findsOneWidget);
      expect(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == 'New User? Sign Up';
      }), findsOneWidget);
    });

    testWidgets('New User? Sign Up onTap takes to SignupView',
        (WidgetTester tester) async {
      await _pumpForgotPasswordView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == 'New User? Sign Up';
      }));
      await tester.pumpAndSettle();

      expect(find.byType(SignupView), findsOneWidget);
    });

    testWidgets(
        'When email is not valid or empty, proper error message should be shown',
        (WidgetTester tester) async {
      var _usersApiMock = getAndRegisterUsersApiMock();
      // var _usersApiMock = MockUsersApi();

      await _pumpForgotPasswordView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.sendResetPasswordInstructions(''));
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });
  });
}
