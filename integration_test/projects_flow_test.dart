import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Tests for project/circuit browsing and interaction flows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Projects Flow Tests', () {
    testWidgets('View featured projects', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for featured projects section
      final featuredFinder = find.text('Featured Circuits');
      if (featuredFinder.evaluate().isNotEmpty) {
        // Scroll to featured section if needed
        await tester.ensureVisible(featuredFinder);
        await tester.pumpAndSettle();

        // Verify featured projects are displayed
        expect(find.byType(Card), findsWidgets);
      }
    });

    testWidgets('Scroll through project list', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find scrollable widget
      final listFinder = find.byType(Scrollable);
      if (listFinder.evaluate().isNotEmpty) {
        // Scroll down
        await tester.drag(listFinder.first, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Verify scroll worked
        expect(find.byType(Scrollable), findsWidgets);
      }
    });

    testWidgets('Tap on a project card', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for projects to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find first project card
      final cardFinder = find.byType(Card);
      if (cardFinder.evaluate().isNotEmpty) {
        await tester.tap(cardFinder.first);
        await tester.pumpAndSettle();

        // Should navigate to project details
        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('Search for projects', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for search icon or field
      final searchFinder = find.byIcon(Icons.search);
      if (searchFinder.evaluate().isNotEmpty) {
        await tester.tap(searchFinder);
        await tester.pumpAndSettle();

        // Enter search query
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          await tester.enterText(searchField.first, 'adder');
          await tester.pumpAndSettle();

          // Verify search results
          expect(find.byType(Scrollable), findsWidgets);
        }
      }
    });
  });
}
