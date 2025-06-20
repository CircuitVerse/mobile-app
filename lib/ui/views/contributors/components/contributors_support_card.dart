import 'package:flutter/material.dart';

class ContributeSupportCard extends StatelessWidget {
  const ContributeSupportCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.cardDescriptionList,
  });

  final String imagePath;
  final String title;
  final List<String> cardDescriptionList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset(imagePath, scale: 2, height: 180),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 16),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  cardDescriptionList
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 3,
                                  right: 8,
                                ),
                                child: Text(
                                  '•',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
