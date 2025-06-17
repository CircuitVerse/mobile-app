import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/ui/components/cv_outline_button.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/home/components/feature_card.dart';
import 'package:mobile_app/ui/views/home/home_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('HomeViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpHomeView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomeView(),
        ),
      );

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds HomeView Widgets', (WidgetTester tester) async {
      await _pumpHomeView(tester);
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(Offset.zero);
      await gesture.moveBy(const Offset(0, -1000));

      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomeView));
      final localizations = AppLocalizations.of(context)!;

      expect(find.text(localizations.home_header_title), findsOneWidget);
      expect(find.byType(CVSubheader), findsNWidgets(2));
      expect(find.byType(CVOutlineButton), findsNWidgets(3));
      expect(find.byType(FeatureCard), findsNWidgets(5));
    });
  });
}
