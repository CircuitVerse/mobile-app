import 'dart:convert';

class IBShowCase {
  bool nextButton, prevButton, tocButton, drawerButton;

  IBShowCase({
    required this.nextButton,
    required this.prevButton,
    required this.tocButton,
    required this.drawerButton,
  });

  factory IBShowCase.fromJson(Map<String, dynamic> json) {
    return IBShowCase(
      nextButton: json['next'] ?? false,
      prevButton: json['prev'] ?? false,
      tocButton: json['toc'] ?? false,
      drawerButton: json['drawer'] ?? false,
    );
  }

  IBShowCase copyWith({
    bool? nextButton,
    bool? prevButton,
    bool? tocButton,
    bool? drawerButton,
  }) {
    return IBShowCase(
      nextButton: nextButton ?? this.nextButton,
      prevButton: prevButton ?? this.prevButton,
      tocButton: tocButton ?? this.tocButton,
      drawerButton: drawerButton ?? this.drawerButton,
    );
  }

  @override
  String toString() {
    return json.encode({
      'next': nextButton,
      'prev': prevButton,
      'toc': tocButton,
      'drawer': drawerButton,
    });
  }
}
