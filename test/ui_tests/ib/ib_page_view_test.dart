import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/ui/views/ib/ib_page_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_ib_raw_page_data.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('IbPageViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpIbPageView(WidgetTester tester) async {
      // Mock ViewModel
      var model = MockIbPageViewModel();
      locator.registerSingleton<IbPageViewModel>(model);

      // Mock Page Data
      when(model.fetchPageData()).thenReturn(null);
      when(model.isSuccess(model.IB_FETCH_PAGE_DATA)).thenAnswer((_) => true);
      when(model.pageData).thenAnswer(
        (_) => IbPageData(
          id: mockIbRawPageData1['path'],
          pageUrl: mockIbRawPageData1['http_url'],
          title: mockIbRawPageData1['title'],
          content: [IbMd(content: mockIbRawPageData1['raw_content'])],
          tableOfContents: [],
        ),
      );

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
          home: IbPageView(
            key: UniqueKey(),
            chapter: _chapter,
            tocCallback: (val) {},
            setPage: (e) {},
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
