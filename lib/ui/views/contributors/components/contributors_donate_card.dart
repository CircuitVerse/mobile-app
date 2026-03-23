import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/utils/url_launcher.dart';

class ContributeDonateCard extends StatefulWidget {
  const ContributeDonateCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.url,
  });

  final String imagePath;
  final String title;
  final String url;

  @override
  State<ContributeDonateCard> createState() => _ContributeDonateCardState();
}

class _ContributeDonateCardState extends State<ContributeDonateCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Column(
        children: <Widget>[
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: CVTheme.textColor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: GestureDetector(
              onTap: () async {
                launchURL(widget.url);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()
                  ..scale(_isHovered ? 1.02 : 1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                    colors: isDark
                        ? [
                            CVTheme.primaryColor.withOpacity(0.2),
                            CVTheme.primaryColorDark.withOpacity(0.3),
                          ]
                        : [
                            Colors.white,
                            CVTheme.primaryColorShadow,
                          ],
                  ),
                  border: Border.all(
                    color: _isHovered
                        ? CVTheme.primaryColor
                        : (isDark ? CVTheme.grey : CVTheme.lightGrey),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? CVTheme.primaryColor.withOpacity(0.3)
                          : (isDark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2)),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: Offset(0, _isHovered ? 6 : 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(24),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsetsDirectional.all(16),
                          child: Image.asset(
                            widget.imagePath,
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: CVTheme.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Support Now',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
