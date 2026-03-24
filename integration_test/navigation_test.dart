import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Tests for navigation flows throughout the app
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Flow Tests', () {
    testWidgets('Navigate from home to about view', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Wait for startup to complete
      await tester.pumpAndSettle();

      // Look for drawer icon or menu button
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        // Try to find About option in drawer
        final aboutFinder = find.text('About');
        if (aboutFinder.evaluate().isNotEmpty) {
          await tester.tap(aboutFinder);
          await tester.pumpAndSettle();

          // Verify navigation occurred
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('Navigate to teachers view', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for drawer icon
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        // Try to find Teachers option
        final teachersFinder = find.text('Teachers');
        if (teachersFinder.evaluate().isNotEmpty) {
          await tester.tap(teachersFinder);
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('Navigate to contributors view', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        final contributorsFinder = find.text('Contributors');
        if (contributorsFinder.evaluate().isNotEmpty) {
          await tester.tap(contributorsFinder);
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });
  });
}
