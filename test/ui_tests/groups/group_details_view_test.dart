import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/groups.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/groups/add_assignment_view.dart';
import 'package:mobile_app/ui/views/groups/components/assignment_card.dart';
import 'package:mobile_app/ui/views/groups/components/member_card.dart';
import 'package:mobile_app/ui/views/groups/edit_group_view.dart';
import 'package:mobile_app/ui/views/groups/group_details_view.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/groups/group_details_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_groups.dart';
import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart' as test;

import '../../setup/test_helpers.mocks.dart';

void main() {
  group('GroupDetailsViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpGroupDetailsView(WidgetTester tester) async {
      // Mock Local Storage
      var _localStorageService = test.getAndRegisterLocalStorageServiceMock();
      when(_localStorageService.currentUser)
          .thenAnswer((_) => User.fromJson(mockUser));

      // Mock GroupDetailsViewModel
      var _groupDetailsViewModel = MockGroupDetailsViewModel();
      locator.registerSingleton<GroupDetailsViewModel>(_groupDetailsViewModel);

      var group = Group.fromJson(mockGroup);

      when(_groupDetailsViewModel.FETCH_GROUP_DETAILS)
          .thenAnswer((_) => 'fetch_group_details');
      when(_groupDetailsViewModel.fetchGroupDetails(any)).thenReturn(null);
      when(_groupDetailsViewModel.group).thenReturn(group);
      when(_groupDetailsViewModel.members).thenReturn([group.groupMembers![0]]);
      when(_groupDetailsViewModel.mentors).thenReturn([]);
      when(_groupDetailsViewModel.assignments).thenReturn(group.assignments!);
      when(_groupDetailsViewModel.isSuccess(any)).thenAnswer((_) => true);
      when(_groupDetailsViewModel.isMentor).thenAnswer((_) => true);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: GroupDetailsView(group: group),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic MyGroupsView widgets',
        (WidgetTester tester) async {
      await _pumpGroupDetailsView(tester);
      await tester.pumpAndSettle();

      // Finds Group Name
      expect(find.text('Test Group'), findsOneWidget);

      // Finds Edit Group Button
      expect(find.text('Edit'), findsNWidgets(2));

      // Finds Mentor Name
      expect(find.byWidgetPredicate((widget) {
        return widget is RichText &&
            widget.text.toPlainText() == 'Primary Mentor : Test User';
      }), findsOneWidget);

      // Make Add Mentors, Add Members and Add Assignments Button
      expect(find.widgetWithText(CVPrimaryButton, '+ Add'), findsNWidgets(3));

      // Finds Member Card (1)
      expect(find.byType(MemberCard), findsOneWidget);

      // Finds Assignments Card (1)
      expect(find.byType(AssignmentCard), findsOneWidget);
    });

    testWidgets('EditGroupView is Pushed onTap Edit Button',
        (WidgetTester tester) async {
      await _pumpGroupDetailsView(tester);
      await tester.pumpAndSettle();

      // Tap Edit Button
      await tester.tap(find.text('Edit').first);
      await tester.pumpAndSettle();

      // Expect EditGroupView is Pushed
      verify(mockObserver.didPush(any, any));
      expect(find.byType(EditGroupView), findsOneWidget);
    });

    testWidgets('Alert Dialog is Pushed on Add Member Button',
        (WidgetTester tester) async {
      await _pumpGroupDetailsView(tester);
      await tester.pumpAndSettle();

      // Tap Add Members button
      await tester.tap(find.widgetWithText(CVPrimaryButton, '+ Add').first);
      await tester.pumpAndSettle();

      // Expect Alert Dialog is visible
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('AddAssignmentView is Pushed onTap Add Assignment Button',
        (WidgetTester tester) async {
      await _pumpGroupDetailsView(tester);
      await tester.pumpAndSettle();

      // Tap Add Assignment Button
      await tester.tap(find.widgetWithText(CVPrimaryButton, '+ Add').last);
      await tester.pumpAndSettle();

      // Expect AddAssignmentView is Pushed
      verify(mockObserver.didPush(any, any));
      expect(find.byType(AddAssignmentView), findsOneWidget);
    });
  });
}
