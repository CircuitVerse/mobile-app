import 'package:flutter/material.dart';
import 'package:mobile_app/utils/url_launcher.dart';

class ContributeDonateCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String url;

  const ContributeDonateCard({
    Key key,
    this.imagePath,
    this.title,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            await launchURL(url);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    offset: Offset(2.0, 2.0),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
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
