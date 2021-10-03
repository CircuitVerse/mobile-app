import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectPreviewFullScreen extends StatelessWidget {
  final String projectImage;
  const ProjectPreviewFullScreen({Key key, this.projectImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Preview'),
      ),
      body: Center(
        child: PhotoView.customChild(
          backgroundDecoration: BoxDecoration(
            color: Colors.white,
          ),
          initialScale: 1.0,
          child: FadeInImage.memoryNetwork(
            height: 100,
            width: 50,
            placeholder: kTransparentImage,
            image: projectImage,
          ),
        ),
      ),
    );
  }
}
