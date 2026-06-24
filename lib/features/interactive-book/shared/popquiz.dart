import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class PopQuiz extends StatelessWidget {
  @Preview(name: 'Pop Quiz')
  const PopQuiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Pop Quiz!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "What is the capital of France?",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 4,
            children: [
              ElevatedButton(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  backgroundColor: Color.fromARGB(255, 194, 193, 194),
                ),
                child: const Text(
                  "Berlin",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  backgroundColor: Color.fromARGB(255, 196, 195, 195),
                ),
                child: const Text(
                  "Paris",
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
