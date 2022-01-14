import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_social_card.dart';
import 'package:mobile_app/ui/components/cv_subheader.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_donate_card.dart';
import 'package:mobile_app/ui/views/contributors/components/contributors_support_card.dart';
import 'package:mobile_app/ui/views/contributors/contributors_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('ContributorsViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpHomeView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const ContributorsView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds ContributorsView Widgets', (WidgetTester tester) async {
      await _pumpHomeView(tester);
      await tester.pumpAndSettle();

      expect(find.byType(CVHeader), findsOneWidget);
      expect(find.byType(CircuitVerseSocialCard), findsNWidgets(3));
      expect(find.byType(CVSubheader), findsOneWidget);
      expect(find.byType(ContributeSupportCard), findsNWidgets(3));
      expect(find.byType(ContributeDonateCard), findsNWidgets(2));
    });
  });
}
