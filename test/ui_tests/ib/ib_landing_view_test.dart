import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
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
      var model = MockIbLandingViewModel();
      locator.registerSingleton<IbLandingViewModel>(model);

      var pageViewModel = MockIbPageViewModel();
      locator.registerSingleton<IbPageViewModel>(pageViewModel);

      // Mock Page View Model
      when(pageViewModel.fetchPageData()).thenReturn(null);
      when(pageViewModel.isSuccess(pageViewModel.IB_FETCH_PAGE_DATA))
          .thenAnswer((_) => true);
      when(pageViewModel.pageData).thenReturn(
          IbPageData(id: 'test', pageUrl: 'test', title: 'test', content: []));

      // Mock Page Drawer List
      when(model.fetchChapters()).thenReturn(null);
      when(model.isSuccess(model.IB_FETCH_CHAPTERS)).thenAnswer((_) => true);
      when(model.chapters).thenAnswer((_) => [
            IbChapter(
              id: 'test',
              value: 'Test Chapter',
              navOrder: '1',
              items: [
                IbChapter(
                  id: 'test-2',
                  value: 'Test Chapter2',
                  navOrder: '2',
                ),
              ],
            )
          ]);

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
      await tester.runAsync(() async {
        await _pumpHomeView(tester);
        await tester.pumpAndSettle();

        // Finds AppBar
        expect(find.byType(AppBar), findsOneWidget);

        // Finds AppBar Text
        expect(find.text('CircuitVerse'), findsOneWidget);

        // Finds Table of Contents Icon
        expect(find.byType(IconButton), findsNWidgets(1));

        // Finds Floating Action Buttons
        expect(find.byType(FloatingActionButton), findsNWidgets(1));
      });
    });

    testWidgets('finds IbPageView Drawer Widgets', (WidgetTester tester) async {
      await tester.runAsync(() async {
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

        // Finds Chapter
        expect(find.text('Test Chapter'), findsOneWidget);
      });
    });
  });
}
