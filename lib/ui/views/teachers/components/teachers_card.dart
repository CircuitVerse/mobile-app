import 'package:flutter/material.dart';

class TeachersCard extends StatelessWidget {
  final String assetPath;
  final String cardHeading;
  final String cardDescription;
  final bool isOdd;

  const TeachersCard({
    Key key,
    this.assetPath,
    this.cardDescription,
    this.cardHeading,
    this.isOdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isOdd ? Color.fromRGBO(245, 255, 252, 1) : Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              assetPath,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              cardHeading,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              cardDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        ],
      ),
    );
  }
}
