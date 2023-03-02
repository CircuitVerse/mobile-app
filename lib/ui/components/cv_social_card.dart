import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/utils/url_launcher.dart';

class CircuitVerseSocialCard extends StatelessWidget {
  const CircuitVerseSocialCard({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.url,
    Key? key,
  }) : super(key: key);

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
        color: Theme.of(context).brightness == Brightness.dark
            ? CVTheme.primaryColor
            : CVTheme.primaryColorShadow,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(imagePath, width: 48),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
