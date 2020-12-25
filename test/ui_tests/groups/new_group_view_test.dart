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

import '../../setup/test_helpers.dart';

void main() {
  group('NewGroupViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpNewGroupView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: NewGroupView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic NewGroupView widgets',
        (WidgetTester tester) async {
      await _pumpNewGroupView(tester);
      await tester.pumpAndSettle();

      // Finds Group Name field
      expect(
          find.byWidgetPredicate((widget) =>
              widget is CVTextField && widget.label == 'Group Name'),
          findsOneWidget);

      // Finds Save button
      expect(find.widgetWithText(CVPrimaryButton, 'SAVE'), findsOneWidget);
    });

    testWidgets('on Save button is Tapped', (WidgetTester tester) async {
      // Mock Dialog Service
      var _dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(_dialogService);

      when(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));
      when(_dialogService.popDialog()).thenReturn(null);

      // Mock New Group View Model
      var _newGroupViewModel = MockNewGroupViewModel();
      locator.registerSingleton<NewGroupViewModel>(_newGroupViewModel);

      when(_newGroupViewModel.addGroup(any)).thenReturn(null);
      when(_newGroupViewModel.isSuccess(_newGroupViewModel.ADD_GROUP))
          .thenReturn(true);

      // Pump New Group View
      await _pumpNewGroupView(tester);
      await tester.pumpAndSettle();

      // Tap Save Details Button
      await tester.enterText(
          find.byWidgetPredicate((widget) =>
              widget is CVTextField && widget.label == 'Group Name'),
          'Test');
      await tester.tap(find.widgetWithText(CVPrimaryButton, 'SAVE'));
      await tester.pumpAndSettle();

      await tester.pump(Duration(seconds: 5));

      // Verify Dialog Service is called to show Dialog of Updating
      verify(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .called(1);
    });
  });
}
