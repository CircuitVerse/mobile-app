import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.assetPath,
    required this.cardDescription,
    required this.cardHeading,
  });

  final String assetPath;
  final String cardHeading;
  final String cardDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.symmetric(vertical: 8),
      elevation: 5,
      child: Column(
        children: <Widget>[
          Image.asset(assetPath, width: 200),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
            child: Text(
              cardHeading,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Container(
            padding: const EdgeInsetsDirectional.all(16),
            child: Text(
              cardDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
