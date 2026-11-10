import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';

/// Generic view shown when content fails to load (no internet, server error..).
class CVErrorView extends StatelessWidget {
  const CVErrorView({this.message, this.onRetry, super.key});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 64, color: CVTheme.textColor(context)),
            const SizedBox(height: 16),
            Text(
              l10n.error_view_title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CVTheme.textColor(context),
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(color: CVTheme.textColor(context)),
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              CVPrimaryButton(title: l10n.error_view_retry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
