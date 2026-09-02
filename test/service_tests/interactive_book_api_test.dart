import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/features/interactive-book/models/navbar.dart';
import 'package:mobile_app/features/interactive-book/services/api.dart';

void main() {
  group('Interactive Book IbApi Test -', () {
    final base = EnvironmentConfig.IB_API_BASE_URL;

    test('builds the navbar, about and guidelines endpoints', () {
      expect(IbApi.navbar().toString(), '$base/navbar.json');
      expect(IbApi.about().toString(), '$base/about.json');
      expect(IbApi.guidelines().toString(), '$base/guidelines.json');
    });

    test('addresses chapter pages by slug, with 0 as the intro page', () {
      expect(
        IbApi.page('binary-representation', 0).toString(),
        '$base/binary-representation/0.json',
      );
      expect(IbApi.page('comb-ssi', 2).toString(), '$base/comb-ssi/2.json');
    });

    test('navbar model keeps the slug each chapter is addressed by', () {
      final navbar = InteractiveBookNavbarModel.fromJson({
        'chapters': [
          {
            'id': 1,
            'name': 'Binary representation',
            'path': 'binary-representation',
            'sub-chapters': [
              {'id': 1, 'name': 'Binary numbers'},
            ],
          },
        ],
      });

      expect(navbar.chapterById(1)?.path, 'binary-representation');
      expect(navbar.chapterById(1)?.subChapters.single.name, 'Binary numbers');
      expect(navbar.chapterById(99), isNull);
    });
  });
}
