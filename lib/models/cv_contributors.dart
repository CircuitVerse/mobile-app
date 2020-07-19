import 'dart:convert';

import 'package:mobile_app/utils/enum_values.dart';

List<CircuitVerseContributors> circuitVerseContributorsFromJson(String str) =>
    List<CircuitVerseContributors>.from(
        json.decode(str).map((x) => CircuitVerseContributors.fromJson(x)));

String circuitVerseContributorsToJson(List<CircuitVerseContributors> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CircuitVerseContributors {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  Type type;
  bool siteAdmin;
  int contributions;

  CircuitVerseContributors({
    this.login,
    this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
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
    this.contributions,
  });

  factory CircuitVerseContributors.fromJson(Map<String, dynamic> json) =>
      CircuitVerseContributors(
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

  Map<String, dynamic> toJson() => {
        'login': login,
        'id': id,
        'node_id': nodeId,
        'avatar_url': avatarUrl,
        'gravatar_id': gravatarId,
        'url': url,
        'html_url': htmlUrl,
        'followers_url': followersUrl,
        'following_url': followingUrl,
        'gists_url': gistsUrl,
        'starred_url': starredUrl,
        'subscriptions_url': subscriptionsUrl,
        'organizations_url': organizationsUrl,
        'repos_url': reposUrl,
        'events_url': eventsUrl,
        'received_events_url': receivedEventsUrl,
        'type': typeValues.reverse[type],
        'site_admin': siteAdmin,
        'contributions': contributions,
      };
}

enum Type { USER, BOT }

final typeValues = EnumValues({'Bot': Type.BOT, 'User': Type.USER});
