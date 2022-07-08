import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_showcase.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/ib/ib_page_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../setup/test_data/mock_ib_raw_page_data.dart';
import '../../setup/test_helpers.mocks.dart';

void main() {
  group('IbPageViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpIbPageView(WidgetTester tester) async {
      // Mock LandingViewModel
      var landingViewModel = MockIbLandingViewModel();
      locator.registerSingleton<IbLandingViewModel>(landingViewModel);

      when(landingViewModel.query).thenAnswer((_) => '');

      // Mock ViewModel
      var model = MockIbPageViewModel();
      locator.registerSingleton<IbPageViewModel>(model);

      // Mock ShowCase State
      var showCase = IBShowCase(
        nextButton: true,
        prevButton: true,
        tocButton: true,
        drawerButton: true,
      );

      // Mock Global Key Map
      const Map<String, dynamic> globalKeyMap = <String, dynamic>{};

      // Mock Page Data
      when(model.IB_FETCH_PAGE_DATA).thenAnswer((_) => 'in_fetch_page_data');
      when(model.fetchPageData()).thenReturn(null);
      when(model.isSuccess(any)).thenAnswer((_) => true);
      when(model.pageData).thenAnswer(
        (_) => IbPageData(
          id: mockIbRawPageData1['path'],
          pageUrl: mockIbRawPageData1['http_url'],
          title: mockIbRawPageData1['title'],
          content: [IbMd(content: mockIbRawPageData1['raw_content'])],
          tableOfContents: [],
        ),
      );
      when(model.nextPage).thenAnswer((_) => GlobalKey());
      when(model.prevPage).thenAnswer((_) => GlobalKey());

      // Mock Page Data
      var _chapter = IbChapter(
        id: mockIbRawPageData1['path'],
        value: mockIbRawPageData1['title'],
        navOrder: '1',
      );

      _chapter.prevPage = _chapter;
      _chapter.nextPage = _chapter;

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: ShowCaseWidget(
            builder: Builder(
              builder: (_) {
                return BaseView<IbLandingViewModel>(
                  builder: (context, model, _) {
                    return IbPageView(
                      key: UniqueKey(),
                      chapter: _chapter,
                      tocCallback: (val) {},
                      setPage: (e) {},
                      showCase: showCase,
                      setShowCase: (e) {},
                      globalKeysMap: globalKeyMap,
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds PageView Widgets', (WidgetTester tester) async {
      await _pumpIbPageView(tester);
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset.zero);
      await gesture.moveBy(const Offset(0, -1000));

      await tester.pumpAndSettle();

      // Finds Text Widgets
      expect(find.byType(Text), findsWidgets);

      // Finds FABs
      expect(find.byType(FloatingActionButton), findsNWidgets(2));

      // Finds IbContent Widgets
      expect(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            (widget.text.toPlainText() == 'Interactive-Book' ||
                widget.text.toPlainText() ==
                    'Learn Digital Logic Design easily.' ||
                widget.text.toPlainText() == 'Audience');
      }), findsNWidgets(3));
      expect(find.byType(Divider), findsNWidgets(1));
    });
  });
}
