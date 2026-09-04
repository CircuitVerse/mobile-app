import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';

class CVException extends StatelessWidget {
  const CVException(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CVTheme.textColor(context),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
