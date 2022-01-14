import 'package:flutter/material.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    Key? key,
    required this.project,
    required this.onPressed,
    this.isHeaderFilled = true,
  }) : super(key: key);

  final Project project;
  final VoidCallback onPressed;
  final bool isHeaderFilled;

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  Widget _buildHeaderChip(String title) {
    return Chip(
      label: Text(title),
      backgroundColor: Colors.black,
      labelStyle: Theme.of(context).textTheme.bodyText1?.copyWith(
            color: Colors.white,
          ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color:
            widget.isHeaderFilled ? CVTheme.primaryColor : Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        border: widget.isHeaderFilled
            ? null
            : const Border.fromBorderSide(
                BorderSide(color: CVTheme.primaryColor),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Text(
              widget.project.attributes.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? widget.isHeaderFilled
                            ? Colors.black
                            : Colors.white
                        : widget.isHeaderFilled
                            ? Colors.white
                            : Colors.black,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          _buildHeaderChip(widget.project.attributes.projectAccessType)
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: CVTheme.primaryColor),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        child: AspectRatio(
          aspectRatio: 1.6,
          child: FadeInImage.memoryNetwork(
            fit: BoxFit.cover,
            placeholder: kTransparentImage,
            image: EnvironmentConfig.CV_API_BASE_URL.substring(
                    0, EnvironmentConfig.CV_API_BASE_URL.length - 7) +
                widget.project.attributes.imagePreview.url,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          shadowColor: CVTheme.primaryColorLight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildHeader(),
              _buildPreview(),
            ],
          ),
        ),
      ),
    );
  }
}
