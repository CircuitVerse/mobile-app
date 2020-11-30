import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/groups/components/group_card_button.dart';
import 'package:mobile_app/ui/views/groups/components/group_member_card.dart';
import 'package:mobile_app/ui/views/groups/components/group_mentor_card.dart';
import 'package:mobile_app/ui/views/groups/edit_group_view.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';
import 'package:mobile_app/ui/views/groups/my_groups_view.dart';
import 'package:mobile_app/ui/views/groups/new_group_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/groups/group_details_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/my_groups_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('MyGroupsViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpMyGroupsView(WidgetTester tester) async {
      var model = MockMyGroupsViewModel();
      locator.registerSingleton<MyGroupsViewModel>(model);

      var groups = <Group>[];
      groups.add(Group.fromJson(mockGroup));

      when(model.fetchMentoredGroups()).thenReturn(null);
      when(model.fetchMemberGroups()).thenReturn(null);

      when(model.isSuccess(model.FETCH_MENTORED_GROUPS))
          .thenAnswer((_) => true);
      when(model.isSuccess(model.FETCH_MEMBER_GROUPS)).thenAnswer((_) => true);

      when(model.mentoredGroups).thenAnswer((_) => groups);
      when(model.memberGroups).thenAnswer((_) => groups);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: MyGroupsView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic MyGroupsView widgets',
        (WidgetTester tester) async {
      await _pumpMyGroupsView(tester);
      await tester.pumpAndSettle();

      // Make New Group Button
      expect(find.widgetWithText(CVPrimaryButton, '+ Make New Group'),
          findsOneWidget);

      // Member Group Card (1)
      expect(find.byType(GroupMemberCard), findsOneWidget);

      // Mentored Group Card (1)
      expect(find.byType(GroupMentorCard), findsOneWidget);

      // Group Names text inside Member and Mentor Card
      expect(find.text('Test Group'), findsNWidgets(2));

      // Total Members text inside Member and Mentor Card
      expect(find.text('Total Members: 1'), findsNWidgets(2));

      // Edit, Delete Buttons for Mentored Group Card
      expect(find.widgetWithText(CardButton, 'Edit'), findsOneWidget);
      expect(find.widgetWithText(CardButton, 'Delete'), findsOneWidget);

      // View Button for Mentored Group Card and Member Group Card
      expect(find.widgetWithText(CardButton, 'View'), findsNWidgets(2));
    });

    testWidgets('New Group Page is Pushed onTap', (WidgetTester tester) async {
      await _pumpMyGroupsView(tester);
      await tester.pumpAndSettle();

      await tester
          .tap(find.widgetWithText(CVPrimaryButton, '+ Make New Group'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(NewGroupView), findsOneWidget);
    });

    testWidgets('View Group Details Page is Pushed onTap',
        (WidgetTester tester) async {
      await _pumpMyGroupsView(tester);
      await tester.pumpAndSettle();

      // Mock Local Storage
      var _localStorage = MockLocalStorageService();
      locator.registerSingleton<LocalStorageService>(_localStorage);

      when(_localStorage.currentUser)
          .thenAnswer((_) => User.fromJson(mockUser));

      // Mock View Model
      var _groupDetailsViewModel = MockGroupDetailsViewModel();
      locator.registerSingleton<GroupDetailsViewModel>(_groupDetailsViewModel);

      when(_groupDetailsViewModel.fetchGroupDetails(any)).thenReturn(null);
      when(_groupDetailsViewModel
              .isSuccess(_groupDetailsViewModel.FETCH_GROUP_DETAILS))
          .thenAnswer((_) => false);

      await tester.tap(find.widgetWithText(CardButton, 'View').first);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(GroupDetailsView), findsOneWidget);
    });

    testWidgets('Edit Group View is Pushed onTap', (WidgetTester tester) async {
      await _pumpMyGroupsView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CardButton, 'Edit'));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(EditGroupView), findsOneWidget);
    });

    testWidgets('Delete Group Dialog is visible onTap',
        (WidgetTester tester) async {
      var _dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(_dialogService);

      // Mock Dialog Service
      when(_dialogService.showConfirmationDialog(
              title: anyNamed('title'),
              description: anyNamed('description'),
              confirmationTitle: anyNamed('confirmationTitle')))
          .thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));

      await _pumpMyGroupsView(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(CardButton, 'Delete'));
      await tester.pumpAndSettle();

      // Verify Dialog Service was called after Delete Button is pressed
      verify(_dialogService.showConfirmationDialog(
              title: anyNamed('title'),
              description: anyNamed('description'),
              confirmationTitle: anyNamed('confirmationTitle')))
          .called(1);
    });
  });
}
