import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/viewmodels/projects/edit_project_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_projects.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('EditProjectViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _project = Project.fromJson(mockProject);

    group('updateProject -', () {
      test('When called & service returns success response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.updateProject('1',
            name: 'Test',
            projectAccessType: 'Public',
            description: 'description',
            tagsList: [])).thenAnswer((_) => Future.value(_project));

        var _model = EditProjectViewModel();
        await _model.updateProject('1',
            name: 'Test',
            projectAccessType: 'Public',
            description: 'description',
            tagsList: []);

        // verify API call is made..
        verify(_mockProjectsApi.updateProject('1',
            name: 'Test',
            projectAccessType: 'Public',
            description: 'description',
            tagsList: []));
        expect(_model.stateFor(_model.updatePROJECT), ViewState.Success);

        // verify project is updated..
        expect(_model.updatedProject, _project);
      });

      test('When called & service returns error', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.updateProject('1',
            name: 'Test',
            projectAccessType: 'Public',
            description: 'description',
            tagsList: [])).thenThrow(Failure('Some Error Occurred!'));

        var _model = EditProjectViewModel();
        await _model.updateProject('1',
            name: 'Test',
            projectAccessType: 'Public',
            description: 'description',
            tagsList: []);

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.updatePROJECT), ViewState.Error);
        expect(_model.errorMessageFor(_model.updatePROJECT),
            'Some Error Occurred!');

        // verify project is not populated on failure
        expect(_model.updatedProject, null);
      });
    });
  });
}
