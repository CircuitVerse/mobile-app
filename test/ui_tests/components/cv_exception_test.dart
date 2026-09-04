import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/ui/components/cv_exception.dart';

void main() {
  testWidgets('shows the failed-to-load message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CVException('Error During Communication')),
      ),
    );

    expect(find.byType(CVException), findsOneWidget);
    expect(find.text('Error During Communication'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
  });
}
