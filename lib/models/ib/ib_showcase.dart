import 'dart:convert';

import 'package:flutter/material.dart';

class IBShowCase {
  bool nextButton, prevButton, contentButton, drawerButton;

  IBShowCase({
    @required this.nextButton,
    @required this.prevButton,
    @required this.contentButton,
    @required this.drawerButton,
  });

  factory IBShowCase.fromJson(Map<String, dynamic> json) {
    return IBShowCase(
      nextButton: json['next'] ?? false,
      prevButton: json['prev'] ?? false,
      contentButton: json['content'] ?? false,
      drawerButton: json['drawer'] ?? false,
    );
  }

  IBShowCase copyWith({
    bool nextButton,
    bool prevButton,
    bool contentButton,
    bool drawerButton,
  }) {
    return IBShowCase(
      nextButton: nextButton ?? this.nextButton,
      prevButton: prevButton ?? this.prevButton,
      contentButton: contentButton ?? this.contentButton,
      drawerButton: drawerButton ?? this.drawerButton,
    );
  }

  @override
  String toString() {
    return json.encode({
      'next': nextButton,
      'prev': prevButton,
      'content': contentButton,
      'drawer': drawerButton,
    });
  }
}
