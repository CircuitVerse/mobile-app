import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/ib/ib_chapter.dart';
import 'package:mobile_app/models/ib/ib_content.dart';
import 'package:mobile_app/models/ib/ib_page_data.dart';
import 'package:mobile_app/models/ib/ib_pop_quiz_question.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/utils/api_utils.dart';
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

        expect(_actualResult!.length, _expectedResult.length);
        expect(_actualResult[0].id, _expectedResult[0].id);
        expect(_actualResult[0].value, _expectedResult[0].value);
        expect(_actualResult[0].prev?.id, _expectedResult[0].prev?.id);
        expect(_actualResult[0].next?.id, _expectedResult[0].next?.id);
        expect(_actualResult[0].items != null, true);

        expect(
            _actualResult[0].items?.length, _expectedResult[0].items?.length);
        expect(_actualResult[0].items?[0].id, _expectedResult[0].items?[0].id);
        expect(_actualResult[0].items?[0].value,
            _expectedResult[0].items?[0].value);
        expect(_actualResult[0].items?[0].prev?.id,
            _expectedResult[0].items?[0].prev?.id);
        expect(_actualResult[0].items?[0].next?.id,
            _expectedResult[0].items?[0].next?.id);
        expect(_actualResult[0].items?[0].items, null);
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
          id: mockIbRawPageData1['name'],
          pageUrl: mockIbRawPageData1['http_url'],
          title: mockIbRawPageData1['title'],
          content: [IbMd(content: mockIbRawPageData1['raw_content'] + '\n')],
          tableOfContents: [],
        );

        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchRawPageData(id: mockIbRawPageData1['name']))
            .thenAnswer((_) =>
                Future.value(IbRawPageData.fromJson(mockIbRawPageData1)));

        var _ibEngine = IbEngineServiceImpl();
        var _actualResult = await _ibEngine.getPageData();

        expect(_actualResult!.id, _expectedResult.id);
        expect(_actualResult.title, _expectedResult.title);
        expect(_actualResult.tableOfContents, _expectedResult.tableOfContents);
        expect(_actualResult.content != null, true);

        expect(_actualResult.content?[0].content,
            _expectedResult.content?[0].content);
      });

      test('When a regular page called and returns success response', () async {
        var mockDataFile =
            File('test/setup/test_data/contributing_guidelines.json');
        Map<String, dynamic> mockIbRawPageData2 =
            jsonDecode(await mockDataFile.readAsString());

        var _expectedResult = IbPageData(
            id: mockIbRawPageData2['path'],
            pageUrl: mockIbRawPageData2['http_url'],
            title: mockIbRawPageData2['title'],
            content: [],
            tableOfContents: [
              IbTocItem(
                leading: '1.',
                content: 'About this guidelines',
                items: [
                  IbTocItem(
                    leading: 'a.',
                    content: 'Revision history',
                  ),
                  IbTocItem(
                    leading: 'b.',
                    content: 'Purpose of the guidelines',
                  ),
                  IbTocItem(
                    leading: 'c.',
                    content: 'Acknowledgements',
                  ),
                ],
              ),
              IbTocItem(
                leading: '2.',
                content: 'Workflow',
              ),
              IbTocItem(
                leading: '3.',
                content: 'Licensing',
                items: [
                  IbTocItem(
                    leading: 'a.',
                    content: 'Non-free materials and special requirements',
                  ),
                  IbTocItem(
                    leading: 'b.',
                    content: 'Linking to copyrighted works',
                  ),
                ],
              ),
              IbTocItem(
                leading: '4.',
                content: 'Proposing a contribution',
              ),
              IbTocItem(
                leading: '5.',
                content: 'Editing existing content',
              ),
              IbTocItem(
                leading: '6.',
                content: 'Writing content',
              ),
              IbTocItem(
                leading: '7.',
                content: 'Style manual',
              ),
              IbTocItem(
                leading: '8.',
                content: 'Templates and examples',
              ),
              IbTocItem(
                leading: '9.',
                content:
                    'Code of conduct, interacting with the community / etiquette',
              ),
              IbTocItem(
                leading: '10.',
                content: 'Tools',
              ),
            ]);

        var _ibApi = getAndRegisterIbApiMock();

        when(_ibApi.fetchRawPageData(id: mockIbRawPageData2['path']))
            .thenAnswer((_) =>
                Future.value(IbRawPageData.fromJson(mockIbRawPageData2)));

        var _ibEngine = IbEngineServiceImpl();
        var _actualResult =
            await _ibEngine.getPageData(id: mockIbRawPageData2['path']);

        expect(_actualResult!.id, _expectedResult.id);
        expect(_actualResult.title, _expectedResult.title);
        expect(_actualResult.tableOfContents?.length,
            _expectedResult.tableOfContents?.length);

        expect(_actualResult.tableOfContents?[0].content,
            _expectedResult.tableOfContents?[0].content);
        expect(_actualResult.tableOfContents?[0].leading,
            _expectedResult.tableOfContents?[0].leading);
        expect(_actualResult.tableOfContents?[0].items?.length,
            _expectedResult.tableOfContents?[0].items?.length);
        expect(_actualResult.tableOfContents?[0].items?[0].content,
            _expectedResult.tableOfContents?[0].items?[0].content);
        expect(_actualResult.tableOfContents?[0].items?[0].leading,
            _expectedResult.tableOfContents?[0].items?[0].leading);
        expect(_actualResult.tableOfContents?[0].items?[1].content,
            _expectedResult.tableOfContents?[0].items?[1].content);
        expect(_actualResult.tableOfContents?[0].items?[1].leading,
            _expectedResult.tableOfContents?[0].items?[1].leading);
        expect(_actualResult.tableOfContents?[0].items?[2].content,
            _expectedResult.tableOfContents?[0].items?[2].content);
        expect(_actualResult.tableOfContents?[0].items?[2].leading,
            _expectedResult.tableOfContents?[0].items?[2].leading);

        expect(_actualResult.tableOfContents?[1].content,
            _expectedResult.tableOfContents?[1].content);
        expect(_actualResult.tableOfContents?[1].leading,
            _expectedResult.tableOfContents?[1].leading);

        expect(_actualResult.tableOfContents?[2].content,
            _expectedResult.tableOfContents?[2].content);
        expect(_actualResult.tableOfContents?[2].leading,
            _expectedResult.tableOfContents?[2].leading);
        expect(_actualResult.tableOfContents?[2].items?.length,
            _expectedResult.tableOfContents?[2].items?.length);
        expect(_actualResult.tableOfContents?[2].items?[0].content,
            _expectedResult.tableOfContents?[2].items?[0].content);
        expect(_actualResult.tableOfContents?[2].items?[0].leading,
            _expectedResult.tableOfContents?[2].items?[0].leading);
        expect(_actualResult.tableOfContents?[2].items?[1].content,
            _expectedResult.tableOfContents?[2].items?[1].content);
        expect(_actualResult.tableOfContents?[2].items?[1].leading,
            _expectedResult.tableOfContents?[2].items?[1].leading);

        expect(_actualResult.tableOfContents?[3].content,
            _expectedResult.tableOfContents?[3].content);
        expect(_actualResult.tableOfContents?[3].leading,
            _expectedResult.tableOfContents?[3].leading);
        expect(_actualResult.tableOfContents?[4].content,
            _expectedResult.tableOfContents?[4].content);
        expect(_actualResult.tableOfContents?[4].leading,
            _expectedResult.tableOfContents?[4].leading);
        expect(_actualResult.tableOfContents?[5].content,
            _expectedResult.tableOfContents?[5].content);
        expect(_actualResult.tableOfContents?[5].leading,
            _expectedResult.tableOfContents?[5].leading);
        expect(_actualResult.tableOfContents?[6].content,
            _expectedResult.tableOfContents?[6].content);
        expect(_actualResult.tableOfContents?[6].leading,
            _expectedResult.tableOfContents?[6].leading);
        expect(_actualResult.tableOfContents?[7].content,
            _expectedResult.tableOfContents?[7].content);
        expect(_actualResult.tableOfContents?[7].leading,
            _expectedResult.tableOfContents?[7].leading);
        expect(_actualResult.tableOfContents?[8].content,
            _expectedResult.tableOfContents?[8].content);
        expect(_actualResult.tableOfContents?[8].leading,
            _expectedResult.tableOfContents?[8].leading);
        expect(_actualResult.tableOfContents?[9].content,
            _expectedResult.tableOfContents?[9].content);
        expect(_actualResult.tableOfContents?[9].leading,
            _expectedResult.tableOfContents?[9].leading);
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

    group('getHtmlInteraction -', () {
      test('When binary embed is called and returns success response',
          () async {
        var _mockJsFile = File('test/setup/test_data/mock_module.js');
        var _mockJs = await _mockJsFile.readAsString();

        var _mockHtmlFile = File('test/setup/test_data/mock_binary.html');
        var _mockHtml = await _mockHtmlFile.readAsString();

        var _expectedResult =
            '<script type="text/javascript">\n$_mockJs\n</script>\n$_mockHtml';
        _expectedResult = _expectedResult.replaceAll(
            RegExp(r'(\.\.(\/\.\.)?)?(?<!org)\/assets'),
            '${EnvironmentConfig.IB_BASE_URL}/assets');

        ApiUtils.client = MockClient((_) {
          if (_.url.toString().endsWith('module.js')) {
            return Future.value(Response(_mockJs, 200));
          }

          return Future.value(Response(_mockHtml, 200));
        });

        var _ibEngine = IbEngineServiceImpl();
        var _actualResult = await _ibEngine.getHtmlInteraction('binary.html');

        expect(_expectedResult, _actualResult);
      });
    });

    group('getPopQuiz -', () {
      test('When a quiz is called and returns success response', () async {
        var _mockPopContent = '''
1. An ALU having `n` selection lines can provide upto _____ operations.
  * 2n
  * n / 2
  1. 2^n
2. Input data can flow in parallel to multiple units inside the ALU.
  1. True
  * False
3. The data is stored in which of the following before ALU accesses it for operation ?
  * ROM memory
  1. Internal registers
  * RAM memory
''';

        var _actualResult = <IbPopQuizQuestion>[
          IbPopQuizQuestion(
            question:
                'An ALU having `n` selection lines can provide upto _____ operations.',
            answers: [2],
            choices: ['2n', 'n / 2', '2^n'],
          ),
          IbPopQuizQuestion(
            question:
                'Input data can flow in parallel to multiple units inside the ALU.',
            answers: [0],
            choices: ['True', 'False'],
          ),
          IbPopQuizQuestion(
            question:
                'The data is stored in which of the following before ALU accesses it for operation ?',
            answers: [1],
            choices: ['ROM memory', 'Internal registers', 'RAM memory'],
          ),
        ];

        var _ibEngine = IbEngineServiceImpl();
        var _expectedResult = _ibEngine.getPopQuiz(_mockPopContent);

        expect(_expectedResult!.length, _actualResult.length);
        expect(_expectedResult[0].question, _actualResult[0].question);
        expect(
            _expectedResult[0].answers.length, _actualResult[0].answers.length);
        expect(_expectedResult[0].answers[0], _actualResult[0].answers[0]);
        expect(
            _expectedResult[0].choices.length, _actualResult[0].choices.length);
        expect(_expectedResult[0].choices[0], _expectedResult[0].choices[0]);
        expect(_expectedResult[0].choices[1], _expectedResult[0].choices[1]);
        expect(_expectedResult[0].choices[2], _expectedResult[0].choices[2]);

        expect(_expectedResult[1].question, _actualResult[1].question);
        expect(
            _expectedResult[1].answers.length, _actualResult[1].answers.length);
        expect(_expectedResult[1].answers[0], _actualResult[1].answers[0]);
        expect(
            _expectedResult[1].choices.length, _actualResult[1].choices.length);
        expect(_expectedResult[1].choices[0], _expectedResult[1].choices[0]);
        expect(_expectedResult[1].choices[1], _expectedResult[1].choices[1]);

        expect(_expectedResult[2].question, _actualResult[2].question);
        expect(
            _expectedResult[2].answers.length, _actualResult[2].answers.length);
        expect(_expectedResult[2].answers[0], _actualResult[2].answers[0]);
        expect(
            _expectedResult[2].choices.length, _actualResult[2].choices.length);
        expect(_expectedResult[2].choices[0], _expectedResult[2].choices[0]);
        expect(_expectedResult[2].choices[1], _expectedResult[2].choices[1]);
        expect(_expectedResult[2].choices[2], _expectedResult[2].choices[2]);
      });
    });

    group('getSlug -', () {
      test('Type 1 - Slug', () {
        expect(IbEngineService.getSlug('Interactive-Book'), 'interactive-book');
        expect(IbEngineService.getSlug('Representing real numbers'),
            'representing-real-numbers');
      });

      test('Type 2 - Slug', () {
        expect(IbEngineService.getSlug('The IEEE 754 Standard'),
            'the-ieee-754-standard');
        expect(IbEngineService.getSlug('1’s complement'), '1s-complement');
      });
    });
  });
}
