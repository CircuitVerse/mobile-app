import 'dart:convert';

import 'package:flutter/material.dart';

class IBShowCase {
  bool nextButton, prevButton, contentButton, drawerButton;

  IBShowCase({
    @required this.nextButton,
    @required this.prevButton,
    @required this.contentButton,
  });

  factory IBShowCase.fromJson(Map<String, dynamic> json) {
    return IBShowCase(
      nextButton: json['next'] ?? false,
      prevButton: json['prev'] ?? false,
      contentButton: json['content'] ?? false,
    );
  }

  IBShowCase copyWith({
    bool nextButton,
    bool prevButton,
    bool contentButton,
  }) {
    return IBShowCase(
      nextButton: nextButton ?? this.nextButton,
      prevButton: prevButton ?? this.prevButton,
      contentButton: contentButton ?? this.contentButton,
    );
  }

  @override
  String toString() {
    return json.encode({
      'next': nextButton,
      'prev': prevButton,
      'content': contentButton,
    });
  }
}
