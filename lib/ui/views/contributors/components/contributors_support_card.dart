import 'package:flutter/material.dart';

class ContributeSupportCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final List<String> cardDescriptionList;

  const ContributeSupportCard({
    Key key,
    this.imagePath,
    this.title,
    this.cardDescriptionList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Image.asset(imagePath, scale: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                cardDescriptionList
                    .map((x) => '\u2022 $x\n')
                    .reduce((x, y) => '$x$y'),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
