import 'package:flutter/material.dart';

class ContributeSupportCard extends StatelessWidget {
  const ContributeSupportCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.cardDescriptionList,
  }) : super(key: key);

  final String imagePath;
  final String title;
  final List<String> cardDescriptionList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Image.asset(imagePath, scale: 2),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
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
