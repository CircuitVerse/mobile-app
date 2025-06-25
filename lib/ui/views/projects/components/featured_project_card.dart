import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:transparent_image/transparent_image.dart';

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

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CVTheme.primaryColor),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        child: AspectRatio(
          aspectRatio: 1.6,
          child:
              hasImage
                  ? FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    placeholder: kTransparentImage,
                    image: _getImageUrl(),
                    imageErrorBuilder:
                        (context, error, stackTrace) =>
                            _buildPlaceholderImage(),
                  )
                  : _buildPlaceholderImage(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
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

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        border: Border.fromBorderSide(BorderSide(color: CVTheme.primaryColor)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              widget.project.attributes.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CVTheme.textColor(context),
              ),
            ),
          ),
          const SizedBox(width: 10),
          CVPrimaryButton.small(title: 'View', onPressed: widget.onViewPressed),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8.0),
      child: Card(
        elevation: 5,
        shadowColor: CVTheme.primaryColorLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[_buildPreview(), _buildFooter()],
        ),
      ),
    );
  }
}
