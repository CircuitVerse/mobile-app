import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/links.dart';

import '../setup/test_data/mock_links.dart';

void main() {
  group('Links Test -', () {
    test('fromJson', () {
      var _links = Links.fromJson(mockLinks);

      expect(_links, isInstanceOf<Links>());

      expect(_links.self, '{url}?page[number]=2');
      expect(_links.first, '{url}?page[number]=1');
      expect(_links.prev, '{url}?page[number]=1');
      expect(_links.next, '{url}?page[number]=3');
      expect(_links.last, '{url}?page[number]=3');
    });
  });
}
