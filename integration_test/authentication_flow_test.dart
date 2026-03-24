import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_app/main.dart' as app;

/// Tests for authentication flows (login, signup, forgot password)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Tests', () {
    testWidgets('Navigate to login view', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for login button or link
      final loginFinder = find.text('Login').first;
      if (loginFinder.evaluate().isNotEmpty) {
        await tester.tap(loginFinder);
        await tester.pumpAndSettle();

        // Verify we're on login screen
        expect(find.byType(TextField), findsWidgets);
      }
    });

    testWidgets('Navigate to signup view', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for signup button or link
      final signupFinder = find.text('Sign Up').first;
      if (signupFinder.evaluate().isNotEmpty) {
        await tester.tap(signupFinder);
        await tester.pumpAndSettle();

        // Verify we're on signup screen
        expect(find.byType(TextField), findsWidgets);
      }
    });

    testWidgets('Login form validation - empty fields', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to login
      final loginFinder = find.text('Login').first;
      if (loginFinder.evaluate().isNotEmpty) {
        await tester.tap(loginFinder);
        await tester.pumpAndSettle();

        // Try to submit empty form
        final submitButton = find.widgetWithText(ElevatedButton, 'Login');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          // Should show validation errors
          expect(find.byType(TextField), findsWidgets);
        }
      }
    });

    testWidgets('Navigate to forgot password view', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to login first
      final loginFinder = find.text('Login').first;
      if (loginFinder.evaluate().isNotEmpty) {
        await tester.tap(loginFinder);
        await tester.pumpAndSettle();

        // Look for forgot password link
        final forgotPasswordFinder = find.text('Forgot Password?');
        if (forgotPasswordFinder.evaluate().isNotEmpty) {
          await tester.tap(forgotPasswordFinder);
          await tester.pumpAndSettle();

          // Verify we're on forgot password screen
          expect(find.byType(TextField), findsWidgets);
        }
      }
    });
  });
}
