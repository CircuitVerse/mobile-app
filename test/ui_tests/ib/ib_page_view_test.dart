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
          id: 'index.md',
          title: 'Home',
          content: [
            IbHeading(content: 'Interactive-Book', type: IbHeadingType.h1),
            IbParagraph(content: 'Learn Digital Logic Design easily.'),
            IbParagraph(
                content:
                    'The Computer Logical Organization is basically the abstraction which is below the operating system and above the digital logic level. Now at this point, the important points are the functional units/subsystems that refer to some hardware which is made up of lower level building blocks. This interactive book gives a complete understanding on Computer Logical Organization starting from basic computer overview till the advanced level. This book is aimed to provide the knowledge to the reader on how to analyze the combinational and sequential circuits and implement them. You can use the combinational circuit/sequential circuit/combination of both the circuits, as per the requirement. After completing this book, you will be able to implement the type of digital circuit, which is suitable for specific application.'),
            IbDivider(),
            IbHeading(content: 'Audience', type: IbHeadingType.h2),
            IbParagraph(
                content:
                    'This book is mainly prepared for the students who are interested in the concepts of digital circuits and Computer Logical Organization. Digital circuits contain a set of Logic gates and these can be operated with binary values, 0 and 1.'),
            IbHeading(content: 'Prerequisites', type: IbHeadingType.h3),
            IbParagraph(
                content:
                    'Before you start learning from this Book, I hope that you have some basic knowledge about computers and how they work. A basic idea regarding the initial concepts of Digital Electronics is enough to understand the topics covered in this tutorial.')
          ],
          tableOfContents: [],
        ),
      );

      // Mock Page Data
      var _chapter = IbChapter(
        id: 'index.md',
        value: 'Home',
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
      expect(find.text('Interactive-Book'), findsOneWidget);
      expect(find.text('Learn Digital Logic Design easily.'), findsOneWidget);
      expect(find.text('Audience'), findsOneWidget);
      expect(find.byType(Divider), findsNWidgets(2));
    });
  });
}
