import 'package:flutter/material.dart';
import 'navbar/navbar.dart';
import 'widgets/features_grid.dart';
import 'widgets/getting_started.dart';

class InteractiveBook extends StatelessWidget {
  const InteractiveBook({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Book')),
      drawer: Navbar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF13B881), Color(0xFF0EA57A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white24,
                      child: const Icon(
                        Icons.menu_book,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Interactive Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Learn · Explore · Thrive',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The Computer Logical Organization is the abstraction below the operating system and above the digital logic level. This interactive book covers computer overview through advanced topics, helping you analyze and implement combinational and sequential circuits for real applications.',
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    const Divider(height: 28),
                    Text(
                      'Audience',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Students interested in digital circuits and computer logical organization. Topics assume basic familiarity with digital electronics and binary logic.',
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                    const Divider(height: 28),
                    Text(
                      'Prerequisites',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'A basic understanding of computers and initial digital electronics concepts is helpful before starting this book.',
                      textAlign: TextAlign.justify,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FeaturesGrid(),
            ),

            const SizedBox(height: 8),

            GettingStarted(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
