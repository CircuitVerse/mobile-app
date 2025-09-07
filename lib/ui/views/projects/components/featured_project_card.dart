import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

class FeaturedProjectCard extends StatefulWidget {
  const FeaturedProjectCard({
    required this.project,
    required this.onViewPressed,
    super.key,
  });

  final Project project;
  final VoidCallback onViewPressed;

  @override
  _FeaturedProjectCardState createState() => _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends State<FeaturedProjectCard> {
  Widget _buildPreview() {
    final hasImage = widget.project.attributes.imagePreview.url.isNotEmpty;
    final isDefaultServerImage = widget.project.attributes.imagePreview.url
        .contains('/assets/empty_project/default-');

    return (hasImage && !isDefaultServerImage)
        ? FadeInImage.memoryNetwork(
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: kTransparentImage,
          image: _getImageUrl(),
          imageErrorBuilder:
              (context, error, stackTrace) => _buildDefaultImage(),
        )
        : _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    return Image.asset(
      'assets/images/projects/default_project_image.png',
      height: 160,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 160,
      width: double.infinity,
      color: Color.lerp(CVTheme.primaryColorLight, Colors.white, 0.95),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bolt,
              size: 48,
              color: Color.lerp(CVTheme.primaryColor, Colors.white, 0.7),
            ),
            const SizedBox(height: 8),
            Text(
              'CircuitVerse Project',
              style: TextStyle(
                color: Color.lerp(CVTheme.primaryColor, Colors.white, 0.4),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImageUrl() {
    final base = Uri.parse(
      EnvironmentConfig.CV_API_BASE_URL,
    ).replace(pathSegments: []).toString().replaceAll(RegExp(r'\/+$'), '');
    return '$base${widget.project.attributes.imagePreview.url}';
  }

  String _stripHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }

  String _getProjectUrl() {
    final base = Uri.parse(
      EnvironmentConfig.CV_API_BASE_URL,
    ).replace(pathSegments: []).toString().replaceAll(RegExp(r'\/+$'), '');
    return '$base/simulator/embed/${widget.project.id}';
  }

  void _shareProject() async {
    final projectUrl = _getProjectUrl();

    try {
      await SharePlus.instance.share(ShareParams(text: projectUrl));
    } catch (e) {
      debugPrint('Error sharing project: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        shadowColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : CVTheme.boxShadow(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPreview(),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.project.attributes.name,
                    style: TextStyle(
                      fontSize: 20,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : CVTheme.primaryHeading(context),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(height: 6),
                  Text(
                    widget.project.attributes.description?.isNotEmpty == true
                        ? _stripHtml(widget.project.attributes.description!)
                        : 'By ${widget.project.attributes.authorName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: CVTheme.textColor(context).withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: <Widget>[
                      if (widget.project.attributes.view > 0) ...[
                        Icon(
                          Icons.visibility,
                          size: 16,
                          color: CVTheme.textColor(
                            context,
                          ).withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.project.attributes.view}',
                          style: TextStyle(
                            fontSize: 12,
                            color: CVTheme.textColor(
                              context,
                            ).withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (widget.project.attributes.starsCount > 0) ...[
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.project.attributes.starsCount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: CVTheme.textColor(
                              context,
                            ).withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                      const Spacer(),
                      IconButton(
                        onPressed: _shareProject,
                        icon: Icon(
                          Icons.share,
                          size: 20,
                          color: CVTheme.textColor(
                            context,
                          ).withValues(alpha: 0.7),
                        ),
                        tooltip: 'Share project',
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.transparent,
                        ),
                        onPressed: widget.onViewPressed,
                        child: Text(
                          AppLocalizations.of(
                            context,
                          )!.featured_projects_card_view,
                          style: TextStyle(
                            color: CVTheme.highlightText(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 5),
          ],
        ),
      ),
    );
  }
}
