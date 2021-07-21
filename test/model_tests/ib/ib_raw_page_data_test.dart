import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/ib/ib_raw_page_data.dart';

import '../../setup/test_data/mock_ib_raw_page_data.dart';

void main() {
  group('IbRawPageData Test -', () {
    test('fromJson', () {
      var _ibRawPageData = IbRawPageData.fromJson(mockIbRawPageData1);

      expect(_ibRawPageData.id, mockIbRawPageData1['path']);
      expect(_ibRawPageData.name, mockIbRawPageData1['name']);
      expect(_ibRawPageData.title, mockIbRawPageData1['title']);
      expect(_ibRawPageData.parent, null);
      expect(
          _ibRawPageData.navOrder, mockIbRawPageData1['nav_order'].toString());
      expect(_ibRawPageData.cvibLevel, null);
      expect(_ibRawPageData.hasChildren, false);
      expect(_ibRawPageData.hasToc, false);
      expect(_ibRawPageData.disableComments, true);
      expect(_ibRawPageData.content, mockIbRawPageData1['content']);
      expect(_ibRawPageData.rawContent, mockIbRawPageData1['raw_content']);
      expect(_ibRawPageData.frontMatter, mockIbRawPageData1['front_matter']);
      expect(_ibRawPageData.httpUrl, mockIbRawPageData1['http_url']);
      expect(_ibRawPageData.apiUrl, mockIbRawPageData1['api_url']);
    });
  });
}
