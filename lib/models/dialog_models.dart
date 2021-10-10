import 'package:flutter/foundation.dart';

class DialogRequest {
  final String? title;
  final String? description;
  final String? buttonTitle;
  final String? cancelTitle;

  DialogRequest({
    required this.title,
    this.description,
    this.buttonTitle,
    this.cancelTitle,
  });
}

class DialogResponse {
  final bool? confirmed;

  DialogResponse({
    this.confirmed,
  });
}
