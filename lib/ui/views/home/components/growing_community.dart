import 'package:flutter/material.dart';

class GrowingCommunityCard extends StatelessWidget {
  const GrowingCommunityCard({super.key});

  Widget _buildStatsCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 229, 244, 228),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Growing Community',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'CircuitVerse has empowered thousands of learners, educators, and engineers worldwide to explore and master digital circuit design',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 40.0,
            mainAxisSpacing: 40.0,
            padding: const EdgeInsets.all(10.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2,
            children: [
              _buildStatsCard('1.3M', 'Circuits Created'),
              _buildStatsCard('314K+', 'Users'),
              _buildStatsCard('4K+', 'Universities'),
              _buildStatsCard('100+', 'Countries'),
            ],
          ),
        ],
      ),
    );
  }
}
