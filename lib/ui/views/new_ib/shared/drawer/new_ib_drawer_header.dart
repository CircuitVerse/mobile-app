import 'package:flutter/material.dart';
import 'package:mobile_app/ib_theme.dart';

class NewIbDrawerHeader extends StatelessWidget {
  const NewIbDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            IbTheme.getPrimaryColor(context),
            IbTheme.getPrimaryColor(context).withAlpha(204),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: IbTheme.getPrimaryColor(context).withAlpha(77),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Interactive Book',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Learn & Explore',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(230),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
