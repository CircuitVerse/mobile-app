import 'package:flutter/material.dart';
import 'package:mobile_app/config/environment_config.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectPreviewFullScreen extends StatelessWidget {
  const ProjectPreviewFullScreen({Key key, this.project}) : super(key: key);

  static const String id = 'project_preview_fullscreen_view';
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.attributes.name),
      ),
      body: Center(
        child: PhotoView.customChild(
          backgroundDecoration: const BoxDecoration(
            color: Colors.white,
          ),
          initialScale: 1.0,
          child: FadeInImage.memoryNetwork(
            height: 100,
            width: 50,
            placeholder: kTransparentImage,
            image: EnvironmentConfig.cvAPIBASEURL
                    .substring(0, EnvironmentConfig.cvAPIBASEURL.length - 7) +
                project.attributes.imagePreview.url,
          ),
        ),
      ),
    );
  }
}
