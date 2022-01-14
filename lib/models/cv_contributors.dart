import 'dart:convert';

import 'package:mobile_app/utils/enum_values.dart';

List<CircuitVerseContributor> circuitVerseContributorsFromJson(String str) =>
    List<CircuitVerseContributor>.from(
        json.decode(str).map((x) => CircuitVerseContributor.fromJson(x)));

class CircuitVerseContributor {
  factory CircuitVerseContributor.fromJson(Map<String, dynamic> json) =>
      CircuitVerseContributor(
        login: json['login'],
        id: json['id'],
        nodeId: json['node_id'],
        avatarUrl: json['avatar_url'],
        gravatarId: json['gravatar_id'],
        url: json['url'],
        htmlUrl: json['html_url'],
        followersUrl: json['followers_url'],
        followingUrl: json['following_url'],
        gistsUrl: json['gists_url'],
        starredUrl: json['starred_url'],
        subscriptionsUrl: json['subscriptions_url'],
        organizationsUrl: json['organizations_url'],
        reposUrl: json['repos_url'],
        eventsUrl: json['events_url'],
        receivedEventsUrl: json['received_events_url'],
        type: typeValues.map[json['type']],
        siteAdmin: json['site_admin'],
        contributions: json['contributions'],
      );
  CircuitVerseContributor({
    this.login,
    required this.id,
    this.nodeId,
    required this.avatarUrl,
    this.gravatarId,
    this.url,
    required this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
    required this.contributions,
  });

  String? login;
  int id;
  String? nodeId;
  String avatarUrl;
  String? gravatarId;
  String? url;
  String htmlUrl;
  String? followersUrl;
  String? followingUrl;
  String? gistsUrl;
  String? starredUrl;
  String? subscriptionsUrl;
  String? organizationsUrl;
  String? reposUrl;
  String? eventsUrl;
  String? receivedEventsUrl;
  Type? type;
  bool? siteAdmin;
  int contributions;
}

enum Type { USER, BOT }

final typeValues = EnumValues({
  'Bot': Type.BOT,
  'User': Type.USER,
});
