import 'package:flutter/material.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D9C7A), Color(0xFF1E7D65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Color(0xFF2D9C7A),
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              const Text(
                "Getting Started",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          const StepItem(
            number: "1",
            title: "Choose a Chapter",
            subtitle: "Browse chapters from the menu",
          ),

          const SizedBox(height: 22),

          const StepItem(
            number: "2",
            title: "Learn Concepts",
            subtitle: "Read through interactive lessons",
          ),

          const SizedBox(height: 22),

          const StepItem(
            number: "3",
            title: "Practice",
            subtitle: "Test your knowledge with quizzes",
          ),
        ],
      ),
    );
  }
}

class StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const StepItem({
    super.key,
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white24,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),

        const SizedBox(width: 18),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
