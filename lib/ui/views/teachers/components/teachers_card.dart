import 'package:flutter/material.dart';

class TeachersCard extends StatelessWidget {
  const TeachersCard({
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
      margin: const EdgeInsetsDirectional.symmetric(vertical: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsetsDirectional.all(8.0),
            child: Image.asset(
              assetPath,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Text(
              cardHeading,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Container(
            padding: const EdgeInsetsDirectional.all(16.0),
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
