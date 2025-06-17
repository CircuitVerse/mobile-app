import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/groups/new_group_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/groups/new_group_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('NewGroupViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpNewGroupView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const NewGroupView(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic NewGroupView widgets', (
      WidgetTester tester,
    ) async {
      await _pumpNewGroupView(tester);

      // Find the MaterialApp widget and get its context
      final materialAppFinder = find.byType(MaterialApp);
      expect(materialAppFinder, findsOneWidget);

      final BuildContext context = tester.element(materialAppFinder.first);
      final localizations = AppLocalizations.of(context);

      // Add null check to prevent null operator usage
      if (localizations != null) {
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is CVTextField &&
                widget.label == localizations.group_name,
          ),
          findsOneWidget,
        );

        expect(
          find.widgetWithText(
            CVPrimaryButton,
            localizations.save.toUpperCase(),
          ),
          findsOneWidget,
        );
      } else {
        // Fallback: search by widget type if localizations are not available
        expect(find.byType(CVTextField), findsOneWidget);
        expect(find.byType(CVPrimaryButton), findsOneWidget);
      }
    });

    testWidgets('on Save button is Tapped', (WidgetTester tester) async {
      var _dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(_dialogService);

      when(
        _dialogService.showCustomProgressDialog(title: anyNamed('title')),
      ).thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));
      when(_dialogService.popDialog()).thenReturn(null);

      var _newGroupViewModel = MockNewGroupViewModel();
      locator.registerSingleton<NewGroupViewModel>(_newGroupViewModel);

      when(_newGroupViewModel.ADD_GROUP).thenAnswer((_) => 'add_group');
      when(_newGroupViewModel.addGroup(any)).thenAnswer((_) async => null);
      when(_newGroupViewModel.isSuccess(any)).thenReturn(true);
      when(_newGroupViewModel.newGroup).thenReturn(null);

      await _pumpNewGroupView(tester);

      // Find the MaterialApp widget and get its context
      final materialAppFinder = find.byType(MaterialApp);
      expect(materialAppFinder, findsOneWidget);

      final BuildContext context = tester.element(materialAppFinder.first);
      final localizations = AppLocalizations.of(context);

      if (localizations != null) {
        // Use localizations if available
        await tester.enterText(
          find.byWidgetPredicate(
            (widget) =>
                widget is CVTextField &&
                widget.label == localizations.group_name,
          ),
          'Test',
        );
        await tester.tap(
          find.widgetWithText(
            CVPrimaryButton,
            localizations.save.toUpperCase(),
          ),
        );
      } else {
        // Fallback: use widget types if localizations not available
        await tester.enterText(find.byType(CVTextField), 'Test');
        await tester.tap(find.byType(CVPrimaryButton));
      }

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      verify(
        _dialogService.showCustomProgressDialog(title: anyNamed('title')),
      ).called(1);
    });
  });
}
