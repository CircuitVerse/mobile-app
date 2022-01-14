import 'package:flutter/material.dart';
import 'package:mobile_app/utils/url_launcher.dart';

class ContributeDonateCard extends StatelessWidget {
  const ContributeDonateCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            launchURL(url);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: Image.asset(
                  imagePath,
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
