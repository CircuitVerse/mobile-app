import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_helpers.dart';

void main() {
  group('IbLandingViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpHomeView(WidgetTester tester) async {
      // Mock ViewModel
      // Mock Page Drawer List

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: IbLandingView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds IbPageView Widgets', (WidgetTester tester) async {
      await _pumpHomeView(tester);
      await tester.pumpAndSettle();

      // Finds AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Finds AppBar Text
      expect(find.text('CircuitVerse'), findsOneWidget);

      // Finds Hamburger Drawer Icon and Table of Contents Icon
      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('finds IbPageView Drawer Widgets', (WidgetTester tester) async {
      await _pumpHomeView(tester);
      await tester.pumpAndSettle();

      // Finds Scaffold
      final state = tester.firstState(find.byType(Scaffold)) as ScaffoldState;
      state.openDrawer();
      await tester.pump();

      // Finds Drawer Widgets
      expect(find.text('Return to Home'), findsOneWidget);
      expect(find.text('Interactive Book Home'), findsOneWidget);
      expect(find.byType(ExpansionTile), findsWidgets);
    });
  });
}
