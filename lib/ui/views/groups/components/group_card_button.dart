import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    required this.onPressed,
    required this.color,
    required this.title,
    Key? key,
  }) : super(key: key);
  final VoidCallback onPressed;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          backgroundColor: color,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
