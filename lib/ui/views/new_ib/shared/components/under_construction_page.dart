import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

/// Under Construction Page
/// 
/// Displays a friendly "Coming Soon" message for chapters and topics
/// that are not yet implemented or when the backend returns an error.
class UnderConstructionPage extends StatelessWidget {
  final String? title;
  final String? message;

  const UnderConstructionPage({
    super.key,
    this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Construction icon
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: IbTheme.getPrimaryColor(context).withAlpha(128),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title ?? 'Coming Soon',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: IbTheme.primaryHeadingColor(context),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Message
            Text(
              message ?? 'This page is under development',
              style: TextStyle(
                fontSize: 16,
                color: IbTheme.textColor(context).withAlpha(179),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Additional info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: IbTheme.getPrimaryColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: IbTheme.getPrimaryColor(context),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      'Check back soon for new content!',
                      style: TextStyle(
                        fontSize: 14,
                        color: IbTheme.textColor(context).withAlpha(204),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
