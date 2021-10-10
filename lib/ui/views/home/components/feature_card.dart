import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String? assetPath;
  final String? cardHeading;
  final String? cardDescription;

  const FeatureCard({
    Key? key,
    this.assetPath,
    this.cardDescription,
    this.cardHeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      child: Column(
        children: <Widget>[
          Image.asset(assetPath!, width: 200),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              cardHeading!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              cardDescription!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
