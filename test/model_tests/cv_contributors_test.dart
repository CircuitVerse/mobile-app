import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/models/cv_contributors.dart';

import '../setup/test_data/mock_contributors.dart';

void main() {
  group('CvContributorsTest -', () {
    test('circuitVerseContributorsFromJson', () {
      circuitVerseContributorsFromJson(jsonEncode(mockContributors)).forEach((
        contributor,
      ) {
        expect(contributor, isInstanceOf<CircuitVerseContributor>());
      });
    });

    test('fromJson', () {
      var _contributor = CircuitVerseContributor.fromJson(mockContributors[0]);

      expect(_contributor.login, 'test');
      expect(_contributor.id, 1);
      expect(_contributor.nodeId, 'MDQ6VXNlcjIyMDIxMTUw');
      expect(
        _contributor.avatarUrl,
        'https://avatars1.githubusercontent.com/u/22021150?v=4',
      );
      expect(_contributor.gravatarId, '');
      expect(_contributor.url, 'https://api.github.com/users/test');
      expect(_contributor.htmlUrl, 'https://github.com/test');
      expect(
        _contributor.followersUrl,
        'https://api.github.com/users/test/followers',
      );
      expect(
        _contributor.followingUrl,
        'https://api.github.com/users/test/following{/other_user}',
      );
      expect(
        _contributor.gistsUrl,
        'https://api.github.com/users/test/gists{/gist_id}',
      );
      expect(
        _contributor.starredUrl,
        'https://api.github.com/users/test/starred{/owner}{/repo}',
      );
      expect(
        _contributor.subscriptionsUrl,
        'https://api.github.com/users/test/subscriptions',
      );
      expect(
        _contributor.organizationsUrl,
        'https://api.github.com/users/test/orgs',
      );
      expect(_contributor.reposUrl, 'https://api.github.com/users/test/repos');
      expect(
        _contributor.eventsUrl,
        'https://api.github.com/users/test/events{/privacy}',
      );
      expect(
        _contributor.receivedEventsUrl,
        'https://api.github.com/users/test/received_events',
      );
      expect(_contributor.type, Type.USER);
      expect(_contributor.siteAdmin, false);
      expect(_contributor.contributions, 114);
    });
  });
}
