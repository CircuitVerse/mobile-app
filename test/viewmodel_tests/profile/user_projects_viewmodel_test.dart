import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_projects.dart';
import '../../setup/test_data/mock_user.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('UserProjectsViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _projects = Projects.fromJson(mockProjects);
    var _project = Project.fromJson(mockProject);
    var _user = User.fromJson(mockUser);

    group('onProjectDeleted -', () {
      test('When called, removes project from _userProjects', () {
        var _model = UserProjectsViewModel();
        _model.userProjects.addAll(_projects.data);
        _model.onProjectDeleted('1');

        expect(
            _model.userProjects
                .where((project) => project.id == _project.id)
                .isEmpty,
            true);
      });
    });

    group('fetchUserFavourites -', () {
      test('When first time fetched & service returns success response',
          () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getUserProjects('1'))
            .thenAnswer((_) => Future.value(_projects));

        var _model = UserProjectsViewModel();
        await _model.fetchUserProjects(userId: '1');

        verify(_mockProjectsApi.getUserProjects('1'));
        expect(_model.stateFor(_model.fetchUserProjectsKey), ViewState.Success);
        expect(_model.previousUserProjectsBatch, _projects);
        expect(deepEq(_model.userProjects, _projects.data), true);
      });

      test('When not first time fetched & service returns success response',
          () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getUserProjects('1', page: 2))
            .thenAnswer((_) => Future.value(_projects));

        var _model = UserProjectsViewModel();
        _model.previousUserProjectsBatch = _projects;
        await _model.fetchUserProjects(userId: '1');

        // verify API call to page 2 is made
        verify(_mockProjectsApi.getUserProjects('1', page: 2));
        expect(_model.stateFor(_model.fetchUserProjectsKey), ViewState.Success);
        expect(_model.previousUserProjectsBatch, _projects);
      });

      test('When userId not passed, API calls is made with _currentUser.id',
          () async {
        var _mockLocalStorageService = getAndRegisterLocalStorageServiceMock();
        when(_mockLocalStorageService.currentUser).thenReturn(_user);

        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getUserProjects('1'))
            .thenAnswer((_) => Future.value(_projects));

        var _model = UserProjectsViewModel();
        await _model.fetchUserProjects();

        // verify API call is made with _currentUser.data.id i.e '1'..
        verify(_mockProjectsApi.getUserProjects('1'));
        expect(_model.stateFor(_model.fetchUserProjectsKey), ViewState.Success);
        expect(_model.previousUserProjectsBatch, _projects);
        expect(deepEq(_model.userProjects, _projects.data), true);
      });

      test('When service returns error response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getUserProjects('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = UserProjectsViewModel();
        await _model.fetchUserProjects(userId: '1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.fetchUserProjectsKey), ViewState.Error);
        expect(_model.errorMessageFor(_model.fetchUserProjectsKey),
            'Some Error Occurred!');
      });
    });
  });
}
