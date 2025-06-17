import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/dialog_models.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/dialog_service.dart';
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
import 'package:mobile_app/gen_l10n/app_localizations.dart';

import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';
import '../../setup/test_helpers.mocks.dart';

void main() {
  group('MyGroupsViewTest -', () {
    late MockNavigatorObserver mockObserver;
    late AppLocalizations localizations;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpMyGroupsView(WidgetTester tester) async {
      var model = MockMyGroupsViewModel();
      locator.registerSingleton<MyGroupsViewModel>(model);

      var groups = <Group>[];
      groups.add(Group.fromJson(mockGroup));

      // Simplified mocking - only what's needed
      when(model.FETCH_OWNED_GROUPS).thenAnswer((_) => 'fetch_owned_groups');
      when(model.FETCH_MEMBER_GROUPS).thenAnswer((_) => 'fetch_member_groups');
      when(model.previousMemberGroupsBatch).thenReturn(null);
      when(model.previousMentoredGroupsBatch).thenReturn(null);
      when(model.fetchMentoredGroups()).thenReturn(null);
      when(model.fetchMemberGroups()).thenReturn(null);
      when(model.isSuccess(any)).thenReturn(true); // Simplified
      when(model.ownedGroups).thenReturn(groups);
      when(model.memberGroups).thenReturn(groups);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const MyGroupsView(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );

      await tester.pumpAndSettle();

      // Get localizations once and store
      final context = tester.element(find.byType(MyGroupsView));
      localizations = AppLocalizations.of(context)!;

      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic MyGroupsView widgets', (
      WidgetTester tester,
    ) async {
      await _pumpMyGroupsView(tester);

      // Make New Group Button
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Tap Joined Groups Tab
      await tester.tap(
        find.widgetWithText(Tab, localizations.my_groups_joined),
      );
      await tester.pumpAndSettle();

      // Member Group Card validations
      expect(find.byType(GroupMemberCard), findsOneWidget);
      expect(find.text('Test Group'), findsOneWidget);
      expect(find.text('Total Members: 1'), findsOneWidget);
      expect(
        find.widgetWithText(CardButton, localizations.my_groups_view),
        findsOneWidget,
      );

      // Tap Owned Groups Tab
      await tester.tap(find.widgetWithText(Tab, localizations.my_groups_owned));
      await tester.pumpAndSettle();

      // Mentor Group Card validations
      expect(find.byType(GroupMentorCard), findsOneWidget);
      expect(find.text('Test Group'), findsOneWidget);
      expect(find.text('Total Members: 1'), findsOneWidget);
      expect(
        find.widgetWithText(CardButton, localizations.my_groups_edit),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CardButton, localizations.my_groups_delete),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CardButton, localizations.my_groups_view),
        findsOneWidget,
      );
    });

    testWidgets('New Group Page is Pushed onTap', (WidgetTester tester) async {
      await _pumpMyGroupsView(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(NewGroupView), findsOneWidget);
    });

    testWidgets('View Group Details Page is Pushed onTap', (
      WidgetTester tester,
    ) async {
      await _pumpMyGroupsView(tester);

      // Setup only what's needed for this test
      var localStorage = getAndRegisterLocalStorageServiceMock();
      when(localStorage.currentUser).thenReturn(User.fromJson(mockUser));

      var groupDetailsViewModel = MockGroupDetailsViewModel();
      locator.registerSingleton<GroupDetailsViewModel>(groupDetailsViewModel);
      when(
        groupDetailsViewModel.FETCH_GROUP_DETAILS,
      ).thenReturn('fetch_group_details');
      when(
        groupDetailsViewModel.fetchGroupDetails(any),
      ).thenAnswer((_) async {});
      when(groupDetailsViewModel.isMentor).thenReturn(false);
      when(groupDetailsViewModel.isSuccess(any)).thenReturn(false);

      await tester.tap(
        find.widgetWithText(CardButton, localizations.my_groups_view).first,
      );
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(GroupDetailsView), findsOneWidget);
    });

    testWidgets('Edit Group View is Pushed onTap', (WidgetTester tester) async {
      await _pumpMyGroupsView(tester);

      await tester.tap(
        find.widgetWithText(CardButton, localizations.my_groups_edit),
      );
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any));
      expect(find.byType(EditGroupView), findsOneWidget);
    });

    testWidgets('Delete Group Dialog is visible onTap', (
      WidgetTester tester,
    ) async {
      var dialogService = MockDialogService();
      locator.registerSingleton<DialogService>(dialogService);

      when(
        dialogService.showConfirmationDialog(
          title: anyNamed('title'),
          description: anyNamed('description'),
          confirmationTitle: anyNamed('confirmationTitle'),
        ),
      ).thenAnswer((_) => Future.value(DialogResponse(confirmed: false)));

      await _pumpMyGroupsView(tester);

      await tester.tap(
        find.widgetWithText(CardButton, localizations.my_groups_delete),
      );
      await tester.pumpAndSettle();

      verify(
        dialogService.showConfirmationDialog(
          title: anyNamed('title'),
          description: anyNamed('description'),
          confirmationTitle: anyNamed('confirmationTitle'),
        ),
      ).called(1);
    });
  });
}
