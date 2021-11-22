import 'package:flutter/foundation.dart';

class DialogRequest {
  DialogRequest({
    @required this.title,
    this.description,
    this.buttonTitle,
    this.cancelTitle,
  });

  final String title;
  final String description;
  final String buttonTitle;
  final String cancelTitle;
}

class DialogResponse {
  DialogResponse({
    this.confirmed,
  });

  final bool confirmed;
}
