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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('SignupViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpSignupView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: Locale('en'),
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: SignupView(),
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

      var _signupImagePredicate =
          (Widget widget) => widget is Image && widget.height == 300;

      expect(find.byWidgetPredicate(_signupImagePredicate), findsOneWidget);
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

      await _pumpSignupView(tester);
      await tester.pumpAndSettle();

      var _nameFieldPredicate =
          (Widget widget) => widget is CVTextField && widget.label == 'Name';
      var _emailFieldPredicate =
          (Widget widget) => widget is CVTextField && widget.label == 'Email';

      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('', '', ''));
      expect(find.text('Name can\'t be empty'), findsOneWidget);
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password can\'t be empty'), findsOneWidget);

      await tester.enterText(
          find.byWidgetPredicate(_nameFieldPredicate), 'test');
      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('test', '', ''));
      expect(find.text('Please enter a valid email'), findsOneWidget);
      expect(find.text('Password can\'t be empty'), findsOneWidget);

      await tester.enterText(
          find.byWidgetPredicate(_emailFieldPredicate), 'test@test.com');
      await tester.tap(find.byType(CVPrimaryButton));
      await tester.pumpAndSettle();

      verifyNever(_usersApiMock.signup('test', 'test@test.com', ''));
      expect(find.text('Password can\'t be empty'), findsOneWidget);
    });
  });
}
