import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/utils/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:math';

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
    double screenWidth = min(MediaQuery.of(context).size.width, 430);
    double dynamicPadding = screenWidth * 0.02;
    double imageWidth = screenWidth * 0.10;
    double buttonSize = screenWidth * 0.08;
    double textWidth =
        screenWidth - imageWidth - buttonSize - (dynamicPadding * 4);
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
          padding: EdgeInsetsDirectional.symmetric(
            vertical: dynamicPadding,
            horizontal: dynamicPadding * 2,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: imageWidth,
                alignment: AlignmentDirectional.centerStart,
                child: Image.asset(imagePath, width: imageWidth),
              ),
              SizedBox(width: dynamicPadding),

              Expanded(
                child: Container(
                  width: textWidth,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: dynamicPadding,
                  ),
                  child: Column(
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
                ),
              ),

              Container(
                width: buttonSize,
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  onPressed: () async {
                    try {
                      await Clipboard.setData(ClipboardData(text: url));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard!'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to copy to clipboard.'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.copy,
                    color: Theme.of(context).iconTheme.color,
                    size: buttonSize * 0.8,
                  ),
                  splashColor: Theme.of(context).splashColor,
                  highlightColor: Theme.of(context).highlightColor,
                  tooltip: 'Copy',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
