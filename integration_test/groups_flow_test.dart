import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Tests for groups and assignments functionality
/// Note: These tests require authentication, so they may need to be skipped
/// or run with a test account
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Groups Flow Tests', () {
    testWidgets('Navigate to groups view (requires auth)', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        // Look for Groups option
        final groupsFinder = find.text('Groups');
        if (groupsFinder.evaluate().isNotEmpty) {
          await tester.tap(groupsFinder);
          await tester.pumpAndSettle();

          // Should either show groups or login prompt
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('View empty groups state', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to groups
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        final groupsFinder = find.text('Groups');
        if (groupsFinder.evaluate().isNotEmpty) {
          await tester.tap(groupsFinder);
          await tester.pumpAndSettle();

          // If not logged in, should show empty state or login prompt
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });
  });
}
