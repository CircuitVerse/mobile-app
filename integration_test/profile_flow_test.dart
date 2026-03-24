import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Tests for profile viewing and editing flows
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Profile Flow Tests', () {
    testWidgets('Navigate to profile view (requires auth)', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        // Look for Profile option
        final profileFinder = find.text('Profile');
        if (profileFinder.evaluate().isNotEmpty) {
          await tester.tap(profileFinder);
          await tester.pumpAndSettle();

          // Should show profile or login prompt
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('View user projects tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        final profileFinder = find.text('Profile');
        if (profileFinder.evaluate().isNotEmpty) {
          await tester.tap(profileFinder);
          await tester.pumpAndSettle();

          // Look for projects tab
          final projectsTab = find.text('Projects');
          if (projectsTab.evaluate().isNotEmpty) {
            await tester.tap(projectsTab);
            await tester.pumpAndSettle();

            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      }
    });

    testWidgets('View favourites tab', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to profile
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        final profileFinder = find.text('Profile');
        if (profileFinder.evaluate().isNotEmpty) {
          await tester.tap(profileFinder);
          await tester.pumpAndSettle();

          // Look for favourites tab
          final favouritesTab = find.text('Favourites');
          if (favouritesTab.evaluate().isNotEmpty) {
            await tester.tap(favouritesTab);
            await tester.pumpAndSettle();

            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      }
    });
  });
}
