import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/views/cv_landing_view.dart';
import 'package:mobile_app/ui/views/startup_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('StartupViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpStartUpView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale('en'),
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const StartUpView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds CircuitVerse logo on StartUpView',
        (WidgetTester tester) async {
      await _pumpStartUpView(tester);

      expect(find.byKey(const Key('cv_startup_logo')), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('HomeView is pushed over StartUpView after 1 second',
        (WidgetTester tester) async {
      await _pumpStartUpView(tester);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      verify(mockObserver.didPush(any, any));
      expect(find.byType(CVLandingView), findsOneWidget);
    });
  });
}
