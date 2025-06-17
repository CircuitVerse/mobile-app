import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/assignments.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/ui/components/cv_html_editor.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/views/groups/update_assignment_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/groups/update_assignment_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../setup/test_data/mock_assignments.dart';
import '../../setup/test_helpers.mocks.dart';

void main() {
  group('UpdateAssignmentViewTest -', () {
    late MockNavigatorObserver mockObserver;
    late AppLocalizations localizations;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
      WebViewPlatform.instance = AndroidWebViewPlatform();
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    tearDown(() {
      if (locator.isRegistered<DialogService>()) {
        locator.unregister<DialogService>();
      }
      if (locator.isRegistered<UpdateAssignmentViewModel>()) {
        locator.unregister<UpdateAssignmentViewModel>();
      }
    });

    Future<void> _pumpUpdateAssignmentView(WidgetTester tester) async {
      var assignment = Assignment.fromJson(mockAssignment);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            ...FlutterQuillLocalizations.localizationsDelegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en', ''),
          home: UpdateAssignmentView(assignment: assignment),
        ),
      );

      await tester.pumpAndSettle();

      // Get localizations once after widget is built
      final context = tester.element(find.byType(UpdateAssignmentView));
      localizations = AppLocalizations.of(context)!;

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic UpdateAssignmentView widgets', (
      WidgetTester tester,
    ) async {
      await _pumpUpdateAssignmentView(tester);

      // Find Name, HTML Editor, Date Time, CheckboxListTile fields
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is CVTextField) {
            return widget.label == localizations.name;
          } else if (widget is CVHtmlEditor) {
            return true;
          } else if (widget is DateTimeField) {
            return widget.key == const Key('cv_assignment_deadline_field');
          } else if (widget is CheckboxListTile) {
            return true;
          }
          return false;
        }),
        findsNWidgets(4),
      );

      expect(find.byType(Checkbox), findsOneWidget);

      // Find Update Assignment button
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is CVPrimaryButton &&
              widget.title == localizations.update_assignment,
        ),
        findsOneWidget,
      );
    });

    testWidgets('on Update Assignment button is Tapped', (
      WidgetTester tester,
    ) async {
      // Mock Dialog Service
      var dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(dialogService);

      when(
        dialogService.showCustomProgressDialog(title: anyNamed('title')),
      ).thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));
      when(dialogService.popDialog()).thenReturn(null);

      // Mock UpdateAssignment ViewModel
      var updateAssignmentViewModel = MockUpdateAssignmentViewModel();
      locator.registerSingleton<UpdateAssignmentViewModel>(
        updateAssignmentViewModel,
      );

      when(
        updateAssignmentViewModel.UPDATE_ASSIGNMENT,
      ).thenReturn('update_assignment');
      when(
        updateAssignmentViewModel.updateAssignment(any, any, any, any, any),
      ).thenAnswer((_) async {});
      when(updateAssignmentViewModel.isSuccess(any)).thenReturn(false);
      when(updateAssignmentViewModel.isError(any)).thenReturn(false);

      await _pumpUpdateAssignmentView(tester);

      // Fill in the name field
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is CVTextField && widget.label == localizations.name,
        ),
        'Test',
      );
      await tester.pumpAndSettle();

      // Tap Update Assignment button
      final buttonFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CVPrimaryButton &&
            widget.title == localizations.update_assignment,
      );

      Widget widget = buttonFinder.evaluate().first.widget;
      (widget as CVPrimaryButton).onPressed!();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      // Verify expected method calls
      verify(
        dialogService.showCustomProgressDialog(title: anyNamed('title')),
      ).called(1);

      verify(
        updateAssignmentViewModel.updateAssignment(any, any, any, any, any),
      ).called(1);
    });
  });
}
