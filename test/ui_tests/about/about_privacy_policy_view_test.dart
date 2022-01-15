import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/views/about/about_privacy_policy_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('AboutPrivacyPolicyTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpAboutPrivacyPolicyView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale('en'),
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const AboutPrivacyPolicyView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds RichText and Text Widgets on AboutTosView',
        (WidgetTester tester) async {
      await _pumpAboutPrivacyPolicyView(tester);

      expect(find.byType(RichText), findsWidgets);
      expect(find.byType(Text), findsWidgets);
    });
  });
}
