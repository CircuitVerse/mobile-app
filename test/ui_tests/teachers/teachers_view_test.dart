import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/teachers/components/teachers_card.dart';
import 'package:mobile_app/ui/views/teachers/teachers_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('TeachersViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpTeachersView(WidgetTester tester) async {
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
          supportedLocales: const [Locale('en', '')],
          locale: const Locale('en', ''),
          home: const TeachersView(),
        ),
      );

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds TeachersView Widgets', (WidgetTester tester) async {
      await _pumpTeachersView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(CVHeader), findsOneWidget);
      expect(find.byType(CVSubheader), findsOneWidget);
      expect(find.byType(TeachersCard), findsNWidgets(4));
    });
  });
}
