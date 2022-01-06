import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_html_editor.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/groups/add_assignment_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/groups/add_assignment_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('AddAssignmentViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpAddAssignmentView(WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const AddAssignmentView(
            groupId: 'Test',
          ),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic AddAssignmentView widgets',
        (WidgetTester tester) async {
      await _pumpAddAssignmentView(tester);
      await tester.pumpAndSettle();

      // Finds Name, HTML Editor, Date Time, DropDown, CheckboxListTile fields
      expect(find.byWidgetPredicate((widget) {
        if (widget is CVTextField) {
          return widget.label == 'Name';
        } else if (widget is CVHtmlEditor) {
          return true;
        } else if (widget is DateTimeField) {
          return widget.key == const Key('cv_assignment_deadline_field');
        } else if (widget is DropdownButtonFormField) {
          return widget.key == const Key('cv_assignment_grading_dropdown');
        } else if (widget is CheckboxListTile) {
          return true;
        }

        return false;
      }), findsNWidgets(5));

      // Finds no elements checkboxes as Elements Restrictions Checkbox is not selected
      expect(find.byType(Checkbox), findsOneWidget);

      // Finds Save button
      expect(find.widgetWithText(CVPrimaryButton, 'Create Assignment'),
          findsOneWidget);
    });

    testWidgets('on Create Assignment button is Tapped',
        (WidgetTester tester) async {
      // Mock Dialog Service
      var _dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(_dialogService);

      when(_dialogService.showCustomProgressDialog())
          .thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));
      when(_dialogService.popDialog()).thenReturn(null);

      // Mock AddAssignment ViewModel
      var _addAssignmentViewModel = MockAddAssignmentViewModel();
      locator
          .registerSingleton<AddAssignmentViewModel>(_addAssignmentViewModel);

      when(_addAssignmentViewModel.ADD_ASSIGNMENT)
          .thenAnswer((_) => 'add_assignment');
      when(_addAssignmentViewModel.addAssignment(any, any, any, any, any, any))
          .thenReturn(null);
      when(_addAssignmentViewModel.isSuccess(any)).thenReturn(false);
      when(_addAssignmentViewModel.isError(any)).thenReturn(false);

      // Pump AddAssignmentView
      await _pumpAddAssignmentView(tester);
      await tester.pumpAndSettle();

      // Tap Save Details Button
      await tester.enterText(
          find.byWidgetPredicate(
              (widget) => widget is CVTextField && widget.label == 'Name'),
          'Test');
      Widget widget = find.byType(CVPrimaryButton).evaluate().first.widget;
      (widget as CVPrimaryButton).onPressed!();
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 5));

      // Verify Dialog Service is called to show Dialog of Updating
      verify(_dialogService.showCustomProgressDialog(title: anyNamed('title')))
          .called(1);
    });
  });
}
