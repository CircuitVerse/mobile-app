import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/utils/url_launcher.dart';
import 'package:flutter/services.dart';

class CircuitVerseSocialCard extends StatelessWidget {
  const CircuitVerseSocialCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.url,
    super.key,
  });

  final String imagePath;
  final String title;
  final String description;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        launchURL(url);
      },
      child: Card(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? CVTheme.primaryColor
                : CVTheme.primaryColorShadow,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(imagePath, width: 48),
              const SizedBox(width: 20),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: -4,
                      child: IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Copied to clipboard!'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: Icon(Icons.copy),
                        tooltip: 'Copy',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CVTheme.textColor(context),
                          ),
                        ),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
