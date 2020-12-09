import 'package:flutter/material.dart';
import 'package:mobile_app/app_theme.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:transparent_image/transparent_image.dart';

class FeaturedProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onViewPressed;

  const FeaturedProjectCard(
      {Key key, @required this.project, this.onViewPressed})
      : super(key: key);

  @override
  _FeaturedProjectCardState createState() => _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends State<FeaturedProjectCard> {
  Widget _buildPreview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryColor),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        child: AspectRatio(
          aspectRatio: 1.6,
          child: FadeInImage.memoryNetwork(
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image:
                '${EnvironmentConfig.CV_API_BASE_URL.substring(0, EnvironmentConfig.CV_API_BASE_URL.length - 7) + widget.project.attributes.imagePreview.url}',
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        border: Border.fromBorderSide(BorderSide(color: AppTheme.primaryColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                widget.project.attributes.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black,
                    ),
              ),
            ),
          ),
          CVPrimaryButton(
            title: 'View',
            padding: EdgeInsets.all(2),
            onPressed: widget.onViewPressed,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shadowColor: AppTheme.primaryColorLight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildPreview(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }
}
