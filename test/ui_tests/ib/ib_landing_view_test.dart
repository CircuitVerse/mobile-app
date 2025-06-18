import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/ui/views/ib/ib_landing_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('IbLandingViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpHomeView(WidgetTester tester) async {
      var model = MockIbLandingViewModel();
      locator.registerSingleton<IbLandingViewModel>(model);

      var pageViewModel = MockIbPageViewModel();
      locator.registerSingleton<IbPageViewModel>(pageViewModel);

      when(model.showSearchBar).thenAnswer((_) => false);
      when(model.homeChapter).thenAnswer(
        (_) => IbChapter(
          id: 'index.md',
          navOrder: '1',
          value: 'Interactive Book Home',
          next: model.chapters[0],
        ),
      );
      when(model.selectedChapter).thenAnswer((_) => model.homeChapter);
      when(model.IB_FETCH_CHAPTERS).thenAnswer((_) => 'ib_fetch_chapters');
      when(model.showCaseState).thenAnswer(
        (_) => IBShowCase(
          nextButton: true,
          prevButton: true,
          tocButton: true,
          drawerButton: true,
        ),
      );
      when(model.keyMap).thenAnswer((_) => {});
      when(model.close()).thenAnswer((_) => {});

      when(
        pageViewModel.IB_FETCH_PAGE_DATA,
      ).thenAnswer((_) => 'mock_fetch_page_data');
      when(pageViewModel.fetchPageData(id: anyNamed('id'))).thenReturn(null);
      when(
        pageViewModel.IB_FETCH_PAGE_DATA,
      ).thenAnswer((_) => 'mock_fetch_page_data');

      when(pageViewModel.isSuccess(any)).thenAnswer((_) => true);
      when(pageViewModel.pageData).thenReturn(
        IbPageData(id: 'test', pageUrl: 'test', title: 'test', content: []),
      );

      when(model.fetchChapters()).thenReturn(null);
      when(model.isSuccess(any)).thenAnswer((_) => true);
      when(model.chapters).thenAnswer(
        (_) => [
          IbChapter(
            id: 'test',
            value: 'Test Chapter',
            navOrder: '1',
            items: [
              IbChapter(id: 'test-2', value: 'Test Chapter2', navOrder: '2'),
            ],
          ),
        ],
      );
      when(model.drawer).thenAnswer((_) => GlobalKey());
      when(model.toc).thenAnswer((_) => GlobalKey());
      when(pageViewModel.nextPage).thenAnswer((_) => GlobalKey());
      when(pageViewModel.prevPage).thenAnswer((_) => GlobalKey());

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
          supportedLocales: AppLocalizations.supportedLocales,
          home: ShowCaseWidget(
            builder:
                (context) => Builder(
                  builder: (context) {
                    return const IbLandingView();
                  },
                ),
          ),
        ),
      );

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds IbPageView Widgets', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await _pumpHomeView(tester);
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(IbLandingView));
        final localizations = AppLocalizations.of(context)!;

        expect(find.byType(AppBar), findsOneWidget);

        expect(find.text(localizations.ib_circuitverse), findsOneWidget);

        expect(find.byType(IconButton), findsNWidgets(2));

        expect(find.byType(FloatingActionButton), findsNWidgets(1));
      });
    });

    testWidgets('finds IbPageView Drawer Widgets', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await _pumpHomeView(tester);
        await tester.pumpAndSettle();

        final context = tester.element(find.byType(IbLandingView));
        final localizations = AppLocalizations.of(context)!;

        final state = tester.firstState(find.byType(Scaffold)) as ScaffoldState;
        state.openDrawer();
        await tester.pump();

        expect(find.text(localizations.ib_return_home), findsOneWidget);
        expect(find.text(localizations.ib_home), findsOneWidget);
        expect(find.byType(ExpansionTile), findsWidgets);

        expect(find.text('Test Chapter'), findsOneWidget);
      });
    });
  });
}
