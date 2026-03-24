import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Basic smoke test to verify app launches successfully
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Launch Tests', () {
    testWidgets('App launches and shows startup view', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify app launches without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
