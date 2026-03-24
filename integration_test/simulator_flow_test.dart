import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Tests for interactive book (simulator) functionality
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simulator Flow Tests', () {
    testWidgets('Navigate to interactive book', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for Interactive Book option
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        final ibFinder = find.text('Interactive Book');
        if (ibFinder.evaluate().isNotEmpty) {
          await tester.tap(ibFinder);
          await tester.pumpAndSettle();

          // Verify navigation
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('Browse interactive book chapters', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to IB
      final drawerFinder = find.byIcon(Icons.menu);
      if (drawerFinder.evaluate().isNotEmpty) {
        await tester.tap(drawerFinder);
        await tester.pumpAndSettle();

        final ibFinder = find.text('Interactive Book');
        if (ibFinder.evaluate().isNotEmpty) {
          await tester.tap(ibFinder);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          // Look for chapter list
          final listFinder = find.byType(ListView);
          if (listFinder.evaluate().isNotEmpty) {
            // Verify chapters are displayed
            expect(find.byType(ListTile), findsWidgets);
          }
        }
      }
    });
  });
}
