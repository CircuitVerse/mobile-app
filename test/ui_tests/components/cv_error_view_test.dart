import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:mobile_app/ui/components/cv_error_view.dart';

void main() {
  testWidgets('CVErrorView shows message and fires retry', (tester) async {
    var retried = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CVErrorView(message: 'No internet', onRetry: () => retried++),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('No internet'), findsOneWidget);
    expect(
      find.text('Please check your connection and try again.'),
      findsNothing,
    );
    await tester.tap(find.text('Retry'));
    expect(retried, 1);
  });

  testWidgets('CVErrorView falls back to localized message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: CVErrorView()),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Please check your connection and try again.'),
      findsOneWidget,
    );
  });
}
