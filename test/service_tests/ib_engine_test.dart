import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mockito/mockito.dart';

import '../setup/test_data/mock_ib_raw_page.dart';
import '../setup/test_data/mock_ib_raw_page_data.dart';
import '../setup/test_helpers.dart';

void main() {
  group('IbEngineService Test -', () {
    setUpAll(() => registerServices());
    tearDownAll(() => unregisterServices());

    group('getChapters -', () {
      test('When called and returns success response', () async {
        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchApiPage(id: ''))
            .thenAnswer((_) => Future.value([mockIbRawPage2, mockIbRawPage3]));

        var ibChapter2 = IbChapter(
          id: mockIbRawPage3['path'],
          navOrder: mockIbRawPage3['nav_order'].toString(),
          value: mockIbRawPage3['title'],
        );

        var ibChapter = IbChapter(
          id: mockIbRawPage2['path'],
          value: mockIbRawPage2['title'],
          navOrder: mockIbRawPage2['nav_order'].toString(),
          next: ibChapter2,
          items: [
            ibChapter2,
          ],
        );

        ibChapter2.prevPage = ibChapter;

        var _expectedResult = [ibChapter];

        var _ibEngine = IbEngineServiceImpl();
        var _actualResult = await _ibEngine.getChapters();

        expect(_actualResult.length, _expectedResult.length);
        expect(_actualResult[0].id, _expectedResult[0].id);
        expect(_actualResult[0].value, _expectedResult[0].value);
        expect(_actualResult[0].prev?.id, _expectedResult[0].prev?.id);
        expect(_actualResult[0].next?.id, _expectedResult[0].next?.id);
        expect(_actualResult[0].items != null, true);

        expect(_actualResult[0].items.length, _expectedResult[0].items.length);
        expect(_actualResult[0].items[0].id, _expectedResult[0].items[0].id);
        expect(
            _actualResult[0].items[0].value, _expectedResult[0].items[0].value);
        expect(_actualResult[0].items[0].prev?.id,
            _expectedResult[0].items[0].prev?.id);
        expect(_actualResult[0].items[0].next?.id,
            _expectedResult[0].items[0].next?.id);
        expect(_actualResult[0].items[0].items, null);
      });

      test('When called and throws Failure', () async {
        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchApiPage(id: ''))
            .thenAnswer((_) => throw Exception('Service Unavailable'));

        var _ibEngine = IbEngineServiceImpl();

        expect(() async => await _ibEngine.getChapters(),
            throwsA(isInstanceOf<Failure>()));
      });
    });

    group('getPageData -', () {
      test('When Home page called and returns success response', () async {
        var _expectedResult = IbPageData(
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
        );

        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchRawPageData(id: 'index.md')).thenAnswer(
            (_) => Future.value(IbRawPageData.fromJson(mockIbRawPageData1)));

        var _ibEngine = IbEngineServiceImpl();
        var _actualResult = await _ibEngine.getPageData();

        expect(_actualResult.id, _expectedResult.id);
        expect(_actualResult.title, _expectedResult.title);
        expect(_actualResult.tableOfContents, _expectedResult.tableOfContents);
        expect(_actualResult.content != null, true);

        expect(_actualResult.content[0].content,
            _expectedResult.content[0].content);
        expect(_actualResult.content[1].content,
            _expectedResult.content[1].content);
        expect(_actualResult.content[2].content,
            _expectedResult.content[2].content);
        expect(_actualResult.content[3].content,
            _expectedResult.content[3].content);
        expect(_actualResult.content[4].content,
            _expectedResult.content[4].content);
        expect(_actualResult.content[5].content,
            _expectedResult.content[5].content);
        expect(_actualResult.content[6].content,
            _expectedResult.content[6].content);
        expect(_actualResult.content[7].content,
            _expectedResult.content[7].content);
      });

      test('When a regular page called and returns success response', () async {
        var mockDataFile =
            await File('test/setup/test_data/contributing_guidelines.json');
        Map<String, dynamic> mockIbRawPageData2 =
            jsonDecode(await mockDataFile.readAsString());

        var _expectedResult = IbPageData(
            id: mockIbRawPageData2['path'],
            title: mockIbRawPageData2['title'],
            content: [],
            tableOfContents: [
              IbTocItem(
                content: '1. About this guidelines',
                items: [
                  IbTocItem(content: 'a. Revision history'),
                  IbTocItem(content: 'b. Purpose of the guidelines'),
                  IbTocItem(content: 'c. Acknowledgements'),
                ],
              ),
              IbTocItem(content: '2. Workflow'),
              IbTocItem(
                content: '3. Licensing',
                items: [
                  IbTocItem(
                      content:
                          'a. Non-free materials and special requirements'),
                  IbTocItem(content: 'b. Linking to copyrighted works'),
                ],
              ),
              IbTocItem(content: '4. Proposing a contribution'),
              IbTocItem(content: '5. Editing existing content'),
              IbTocItem(content: '6. Writing content'),
              IbTocItem(content: '7. Style manual'),
              IbTocItem(content: '8. Templates and examples'),
              IbTocItem(
                  content:
                      '9. Code of conduct, interacting with the community / etiquette'),
              IbTocItem(content: '10. Tools'),
            ]);

        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchRawPageData(id: mockIbRawPageData2['path']))
            .thenAnswer((_) =>
                Future.value(IbRawPageData.fromJson(mockIbRawPageData2)));

        var _ibEngine = IbEngineServiceImpl();
        var _actualResult =
            await _ibEngine.getPageData(id: mockIbRawPageData2['path']);

        expect(_actualResult.id, _expectedResult.id);
        expect(_actualResult.title, _expectedResult.title);
        expect(_actualResult.tableOfContents.length,
            _expectedResult.tableOfContents.length);

        // [TODO] Tests for Content

        expect(_actualResult.tableOfContents[0].content,
            _expectedResult.tableOfContents[0].content);
        expect(_actualResult.tableOfContents[0].items.length,
            _expectedResult.tableOfContents[0].items.length);
        expect(_actualResult.tableOfContents[0].items[0].content,
            _expectedResult.tableOfContents[0].items[0].content);
        expect(_actualResult.tableOfContents[0].items[1].content,
            _expectedResult.tableOfContents[0].items[1].content);
        expect(_actualResult.tableOfContents[0].items[2].content,
            _expectedResult.tableOfContents[0].items[2].content);

        expect(_actualResult.tableOfContents[1].content,
            _expectedResult.tableOfContents[1].content);

        expect(_actualResult.tableOfContents[2].content,
            _expectedResult.tableOfContents[2].content);
        expect(_actualResult.tableOfContents[2].items.length,
            _expectedResult.tableOfContents[2].items.length);
        expect(_actualResult.tableOfContents[2].items[0].content,
            _expectedResult.tableOfContents[2].items[0].content);
        expect(_actualResult.tableOfContents[2].items[1].content,
            _expectedResult.tableOfContents[2].items[1].content);

        expect(_actualResult.tableOfContents[3].content,
            _expectedResult.tableOfContents[3].content);
        expect(_actualResult.tableOfContents[4].content,
            _expectedResult.tableOfContents[4].content);
        expect(_actualResult.tableOfContents[5].content,
            _expectedResult.tableOfContents[5].content);
        expect(_actualResult.tableOfContents[6].content,
            _expectedResult.tableOfContents[6].content);
        expect(_actualResult.tableOfContents[7].content,
            _expectedResult.tableOfContents[7].content);
        expect(_actualResult.tableOfContents[8].content,
            _expectedResult.tableOfContents[8].content);
        expect(_actualResult.tableOfContents[9].content,
            _expectedResult.tableOfContents[9].content);
      });

      test('When called and throws Failure', () async {
        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchRawPageData(id: 'index.md'))
            .thenAnswer((_) => throw Exception('Service Unavailable'));

        var _ibEngine = IbEngineServiceImpl();

        expect(() async => await _ibEngine.getPageData(),
            throwsA(isInstanceOf<Failure>()));
      });
    });
  });
}
