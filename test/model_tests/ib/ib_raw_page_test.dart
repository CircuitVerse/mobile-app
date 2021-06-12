import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/ib/ib_raw_page.dart';

import '../../setup/test_data/mock_ib_raw_page.dart';

void main() {
  group('IbRawPage Test -', () {
    test('fromJson - Type 1', () {
      var _ibRawPage = IbRawPage.fromJson(mockIbRawPage1);

      expect(_ibRawPage.id, mockIbRawPage1['path']);
      expect(_ibRawPage.name, mockIbRawPage1['name']);
      expect(_ibRawPage.title, mockIbRawPage1['title']);
      expect(_ibRawPage.parent, null);
      expect(_ibRawPage.navOrder, mockIbRawPage1['nav_order'].toString());
      expect(_ibRawPage.cvibLevel, null);
      expect(_ibRawPage.hasChildren, false);
      expect(_ibRawPage.hasToc, false);
      expect(_ibRawPage.disableComments, true);
      expect(_ibRawPage.httpUrl, mockIbRawPage1['http_url']);
      expect(_ibRawPage.apiUrl, mockIbRawPage1['api_url']);
    });

    test('fromJson - Type 2', () {
      var _ibRawPage = IbRawPage.fromJson(mockIbRawPage2);

      expect(_ibRawPage.id, mockIbRawPage2['path']);
      expect(_ibRawPage.name, mockIbRawPage2['name']);
      expect(_ibRawPage.title, mockIbRawPage2['title']);
      expect(_ibRawPage.parent, null);
      expect(_ibRawPage.navOrder, mockIbRawPage2['nav_order'].toString());
      expect(_ibRawPage.cvibLevel, null);
      expect(_ibRawPage.hasChildren, mockIbRawPage2['has_children']);
      expect(_ibRawPage.hasToc, mockIbRawPage2['has_toc']);
      expect(_ibRawPage.disableComments, true);
      expect(_ibRawPage.httpUrl, mockIbRawPage2['http_url']);
      expect(_ibRawPage.apiUrl, mockIbRawPage2['api_url']);
    });

    test('fromJson - Type 3', () {
      var _ibRawPage = IbRawPage.fromJson(mockIbRawPage3);

      expect(_ibRawPage.id, mockIbRawPage3['path']);
      expect(_ibRawPage.name, mockIbRawPage3['name']);
      expect(_ibRawPage.title, mockIbRawPage3['title']);
      expect(_ibRawPage.parent, mockIbRawPage3['parent']);
      expect(_ibRawPage.navOrder, mockIbRawPage3['nav_order'].toString());
      expect(_ibRawPage.cvibLevel, mockIbRawPage3['cvib_level']);
      expect(_ibRawPage.hasChildren, mockIbRawPage3['has_children']);
      expect(_ibRawPage.hasToc, true);
      expect(_ibRawPage.disableComments, false);
      expect(_ibRawPage.httpUrl, mockIbRawPage3['http_url']);
      expect(_ibRawPage.apiUrl, mockIbRawPage3['api_url']);
    });
  });
}
