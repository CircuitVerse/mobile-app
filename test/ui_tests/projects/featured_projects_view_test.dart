import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/ui/components/cv_header.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/views/projects/components/featured_project_card.dart';
import 'package:mobile_app/ui/views/projects/featured_projects_view.dart';
import 'package:mobile_app/ui/views/projects/project_details_view.dart';
import '../../setup/test_helpers.mocks.dart';
import '../../utils_tests/image_test_utils.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../setup/test_data/mock_projects.dart';

void main() {
  group('FeaturedProjectsViewTest -', () {
    late MockNavigatorObserver mockObserver;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await setupLocator();
      locator.allowReassignment = true;
    });

    setUp(() => mockObserver = MockNavigatorObserver());

    Future<void> _pumpFeaturedProjectsView(WidgetTester tester) async {
      var model = MockFeaturedProjectsViewModel();
      locator.registerSingleton<FeaturedProjectsViewModel>(model);

      var projects = <Project>[];
      projects.add(Project.fromJson(mockProject));

      when(model.FETCH_FEATURED_PROJECTS)
          .thenAnswer((_) => 'fetch_featured_projects');
      when(model.SEARCH_PROJECTS).thenAnswer((_) => 'search_projects');
      when(model.isBusy(any)).thenAnswer((_) => false);
      when(model.fetchFeaturedProjects()).thenReturn(null);

      when(model.isSuccess(any)).thenAnswer((_) => true);

      when(model.projects).thenAnswer((_) => projects);
      when(model.showSearchBar).thenAnswer((_) => false);
      when(model.previousProjectsBatch).thenAnswer((_) => null);

      await tester.pumpWidget(
        GetMaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: const Locale('en'),
          onGenerateRoute: CVRouter.generateRoute,
          navigatorObservers: [mockObserver],
          home: const FeaturedProjectsView(),
        ),
      );

      /// The tester.pumpWidget() call above just built our app widget
      /// and triggered the pushObserver method on the mockObserver once.
      verify(mockObserver.didPush(any, any));
    }

    testWidgets('finds Generic MyGroupsView widgets',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        await _pumpFeaturedProjectsView(tester);
        await tester.pumpAndSettle();

        // Finds CVHeader
        expect(find.byType(CVHeader), findsOneWidget);

        // Finds Project Card
        expect(find.byType(FeaturedProjectCard), findsOneWidget);
      });
    });

    testWidgets('Project Page is Pushed onTap View button',
        (WidgetTester tester) async {
      await provideMockedNetworkImages(() async {
        await _pumpFeaturedProjectsView(tester);
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

        expect(find.widgetWithText(CVPrimaryButton, 'View'), findsOneWidget);

        // ISSUE: tester.tap() is not working
        Widget button = find
            .widgetWithText(CVPrimaryButton, 'View')
            .evaluate()
            .first
            .widget;
        (button as CVPrimaryButton).onPressed!();
        await tester.pumpAndSettle();

        verify(mockObserver.didPush(any, any));
        expect(find.byType(ProjectDetailsView), findsOneWidget);
      });
    });
  });
}
