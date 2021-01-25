import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/views/profile/user_projects_view.dart';
import 'package:mobile_app/ui/views/projects/components/project_card.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import 'package:mobile_app/utils/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setup/test_data/mock_projects.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('UserProjectsViewTest -', () {
    NavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = NavigatorObserverMock());

    Future<void> _pumpUserProjectsView(WidgetTester tester) async {
      // Mock User Projects ViewModel
      var _userProjectsViewModel = MockUserProjectsViewModel();
      locator.registerSingleton<UserProjectsViewModel>(_userProjectsViewModel);

      var projects = <Project>[];
      projects.add(Project.fromJson(mockProject));

      when(_userProjectsViewModel.fetchUserProjects()).thenReturn(null);
      when(_userProjectsViewModel
              .isSuccess(_userProjectsViewModel.FETCH_USER_PROJECTS))
          .thenReturn(true);
      when(_userProjectsViewModel.userProjects).thenAnswer((_) => projects);

      await tester.pumpWidget(
        GetMaterialApp(
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: Scaffold(
            body: UserProjectsView(),
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

        when(projectDetailsViewModel.fetchProjectDetails(any)).thenReturn(null);
        when(projectDetailsViewModel.isSuccess(any)).thenReturn(false);

        expect(find.byType(ProjectCard), findsOneWidget);

        // ISSUE: tester.tap() is not working
        ProjectCard widget = find.byType(ProjectCard).evaluate().first.widget;
        widget.onPressed();
        await tester.pumpAndSettle();

        verify(mockObserver.didPush(any, any));
        expect(find.byType(ProjectDetailsView), findsOneWidget);
      });
    });
  });
}
