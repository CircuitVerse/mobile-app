import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await setupLocator();
  });

  testWidgets('Sample test', (WidgetTester tester) async {
    await tester.pumpWidget(CircuitVerseMobile());
    await tester.pumpAndSettle(Duration(seconds: 1));
    expect(true, true);
  });
}
