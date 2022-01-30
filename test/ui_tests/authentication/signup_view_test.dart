import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/components/cv_password_field.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/authentication/signup_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_helpers.dart';
import '../../setup/test_helpers.mocks.dart';

void main() {
  group('SignupViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpSignupView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const SignupView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic SignupView widgets',
        (WidgetTester tester) async {
      await _pumpSignupView(tester);
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate(
              (Widget widget) => widget is Image && widget.height == 300),
          findsOneWidget);
      expect(find.byType(CVTextField), findsNWidgets(2));
      expect(find.byType(CVPasswordField), findsOneWidget);
      expect(find.byType(CVPrimaryButton), findsOneWidget);
      expect(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == 'Already Registered? Login';
      }), findsOneWidget);
    });

    testWidgets(
        'When name/email/password is not valid or empty, proper error message should be shown',
        (WidgetTester tester) async {
      var _usersApiMock = getAndRegisterUsersApiMock();
      // var _usersApiMock = MockUsersApi();

      await _pumpSignupView(tester);
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is CVTextField && widget.label == 'Name'),
          findsOneWidget);

      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('', '', ''));
      expect(find.text('Name can\'t be empty'), findsOneWidget);
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password can\'t be empty'), findsOneWidget);

      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is CVTextField && widget.label == 'Name'),
          'test');
      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('test', '', ''));
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password can\'t be empty'), findsOneWidget);

      await tester.enterText(
          find.byWidgetPredicate((Widget widget) =>
              widget is CVTextField && widget.label == 'Email'),
          'test@test.com');
      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('test', 'test@test.com', ''));
      expect(find.text('Password can\'t be empty'), findsOneWidget);

      await tester.enterText(
          find.byWidgetPredicate((Widget widget) => widget is CVPasswordField),
          'abcd');
      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('test', 'test@test.com', 'abcd'));
      expect(find.text('Password length should be at least 6'), findsOneWidget);
    });
  });
}
