import 'package:flutter/material.dart';

class CVException extends StatelessWidget {
  final String message;
  CVException(this.message);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}
