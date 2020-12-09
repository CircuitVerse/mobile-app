import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_projects.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('FeaturedProjectsViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _projects = Projects.fromJson(mockProjects);

    group('fetchFeaturedProjects -', () {
      test('When first time fetched & service returns success response',
          () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getFeaturedProjects())
            .thenAnswer((_) => Future.value(_projects));

        var _model = FeaturedProjectsViewModel();
        await _model.fetchFeaturedProjects();

        verify(_mockProjectsApi.getFeaturedProjects());
        expect(
            _model.stateFor(_model.FETCH_FEATURED_PROJECTS), ViewState.Success);
        expect(_model.previousFeaturedProjectsBatch, _projects);
        expect(deepEq(_model.featuredProjects, _projects.data), true);
      });

      test('When not first time fetched & service returns success response',
          () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getFeaturedProjects(page: 2))
            .thenAnswer((_) => Future.value(_projects));

        var _model = FeaturedProjectsViewModel();
        _model.previousFeaturedProjectsBatch = _projects;
        await _model.fetchFeaturedProjects();

        // verify API call to page 2 is made
        verify(_mockProjectsApi.getFeaturedProjects(page: 2));
        expect(
            _model.stateFor(_model.FETCH_FEATURED_PROJECTS), ViewState.Success);
        expect(_model.previousFeaturedProjectsBatch, _projects);
      });

      test('When service returns error response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getFeaturedProjects())
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = FeaturedProjectsViewModel();
        await _model.fetchFeaturedProjects();

        // verify Error ViewState with proper error message..
        expect(
            _model.stateFor(_model.FETCH_FEATURED_PROJECTS), ViewState.Error);
        expect(_model.errorMessageFor(_model.FETCH_FEATURED_PROJECTS),
            'Some Error Occurred!');
      });
    });
  });
}
