import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/ui/views/profile/user_projects_view.dart';
import 'package:mobile_app/ui/views/projects/components/project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import '../../setup/test_helpers.mocks.dart';
import '../../utils_tests/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_projects.dart';

void main() {
  group('UserProjectsViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpUserProjectsView(WidgetTester tester) async {
      // Mock User Profile ViewModel
      final _profileViewModel = MockProfileViewModel();
      locator.registerSingleton<ProfileViewModel>(_profileViewModel);

      // Mock User Projects ViewModel
      var _userProjectsViewModel = MockUserProjectsViewModel();
      locator.registerSingleton<UserProjectsViewModel>(_userProjectsViewModel);

      var projects = <Project>[];
      projects.add(Project.fromJson(mockProject));

      when(_userProjectsViewModel.FETCH_USER_PROJECTS)
          .thenAnswer((_) => 'fetch_user_projects');
      when(_userProjectsViewModel.fetchUserProjects(userId: anyNamed('userId')))
          .thenReturn(null);
      when(_userProjectsViewModel.isSuccess(any)).thenReturn(true);
      when(_userProjectsViewModel.userProjects).thenAnswer((_) => projects);
      when(_userProjectsViewModel.previousUserProjectsBatch)
          .thenAnswer((_) => null);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: BaseView<ProfileViewModel>(
            builder: (context, model, child) {
              return const Scaffold(
                body: UserProjectsView(
                  userId: 'user_id',
                ),
              );
            },
          ),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic UserProjectsView widgets',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        await _pumpUserProjectsView(tester);
        await tester.pumpAndSettle();

        // Finds Project Card
        expect(find.byType(ProjectCard), findsOneWidget);
      });
    });

    testWidgets('Project Page is Pushed onTap View button',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        await _pumpUserProjectsView(tester);
        await tester.pumpAndSettle();

        var projectDetailsViewModel = MockProjectDetailsViewModel();
        locator.registerSingleton<ProjectDetailsViewModel>(
            projectDetailsViewModel);

        final _recievedProject = Project.fromJson(mockProject);
        when(projectDetailsViewModel.receivedProject)
            .thenAnswer((_) => _recievedProject);
        when(projectDetailsViewModel.isLoggedIn).thenAnswer((_) => true);
        when(projectDetailsViewModel.isProjectStarred)
            .thenAnswer((_) => _recievedProject.attributes.isStarred);
        when(projectDetailsViewModel.starCount).thenAnswer((_) => 0);
        when(projectDetailsViewModel.FETCH_PROJECT_DETAILS)
            .thenAnswer((_) => 'fetch_project_details');
        when(projectDetailsViewModel.fetchProjectDetails(any)).thenReturn(null);
        when(projectDetailsViewModel.isSuccess(any)).thenReturn(false);

        expect(find.byType(ProjectCard), findsOneWidget);

        // ISSUE: tester.tap() is not working
        Widget widget = find.byType(ProjectCard).evaluate().first.widget;
        (widget as ProjectCard).onPressed();
        await tester.pumpAndSettle();

        verify(mockObserver.didPush(any, any));
        expect(find.byType(ProjectDetailsView), findsOneWidget);
      });
    });
  });
}
