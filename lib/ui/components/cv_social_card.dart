import 'package:flutter/material.dart';
import 'package:mobile_app/utils/url_launcher.dart';

class CircuitVerseSocialCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String url;

  const CircuitVerseSocialCard({
    Key key,
    this.imagePath,
    this.title,
    this.description,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launchURL(url);
      },
      child: Card(
        color: Color.fromRGBO(245, 255, 252, 1),
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.asset(imagePath, width: 48),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
