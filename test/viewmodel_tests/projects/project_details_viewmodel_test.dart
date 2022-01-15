import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/models/add_collaborator_response.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/projects.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
import 'package:mockito/mockito.dart';

import '../../setup/test_data/mock_add_collaborators_response.dart';
import '../../setup/test_data/mock_collaborators.dart';
import '../../setup/test_data/mock_projects.dart';
import '../../setup/test_helpers.dart';

void main() {
  group('ProjectDetailsViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    var _project = Project.fromJson(mockProject);
    var _collaborators = Collaborators.fromJson(mockCollaborators);
    var _collaborator = Collaborator.fromJson(mockCollaborator);
    var _addedCollaborators =
        AddCollaboratorsResponse.fromJson(mockAddCollaboratorsResponse);

    group('fetchGroupDetails -', () {
      test('When called & service returns success response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getProjectDetails('1'))
            .thenAnswer((_) => Future.value(_project));

        var _model = ProjectDetailsViewModel();
        await _model.fetchProjectDetails('1');

        // verify API call is made..
        verify(_mockProjectsApi.getProjectDetails('1'));
        expect(_model.stateFor(_model.fetchPROJECTDETAILS), ViewState.Success);

        // verify project data is populated..
        expect(_model.project, _project);
        expect(_model.collaborators, _project.collaborators);
      });

      test('When called & service returns error', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.getProjectDetails('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProjectDetailsViewModel();
        await _model.fetchProjectDetails('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.fetchPROJECTDETAILS), ViewState.Error);
        expect(_model.errorMessageFor(_model.fetchPROJECTDETAILS),
            'Some Error Occurred!');
      });
    });

    group('addCollaborators -', () {
      test('When called & service returns success response', () async {
        var _mockCollaboratorsApi = getAndRegisterCollaboratorsApiMock();
        when(_mockCollaboratorsApi.addCollaborators(
                '1', 'test@test.com,existing@test.com,invalid@test.com'))
            .thenAnswer((_) => Future.value(_addedCollaborators));

        when(_mockCollaboratorsApi.fetchProjectCollaborators('1'))
            .thenAnswer((_) => Future.value(_collaborators));

        var _model = ProjectDetailsViewModel();
        await _model.addCollaborators(
            '1', 'test@test.com,existing@test.com,invalid@test.com');

        // verify API call is made..
        verify(_mockCollaboratorsApi.addCollaborators(
            '1', 'test@test.com,existing@test.com,invalid@test.com'));
        verify(_mockCollaboratorsApi.fetchProjectCollaborators('1'));
        expect(_model.stateFor(_model.addCOLLABORATORS), ViewState.Success);

        expect(_model.addedCollaboratorsSuccessMessage,
            'test@test.com was/were added existing@test.com is/are existing invalid@test.com is/are invalid');
        expect(_model.collaborators, _collaborators.data);
      });

      test('When called & service returns error', () async {
        var _mockCollaboratorsApi = getAndRegisterCollaboratorsApiMock();
        when(_mockCollaboratorsApi.addCollaborators(
                '1', 'test@test.com,existing@test.com,invalid@test.com'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProjectDetailsViewModel();
        await _model.addCollaborators(
            '1', 'test@test.com,existing@test.com,invalid@test.com');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.addCOLLABORATORS), ViewState.Error);
        expect(_model.errorMessageFor(_model.addCOLLABORATORS),
            'Some Error Occurred!');
      });
    });

    group('deleteGroupMember -', () {
      test('When called & service returns success/true response', () async {
        var _mockCollaboratorsApi = getAndRegisterCollaboratorsApiMock();
        when(_mockCollaboratorsApi.deleteCollaborator('1', '1'))
            .thenAnswer((_) => Future.value(true));

        var _model = ProjectDetailsViewModel();
        _model.collaborators.add(_collaborator);
        await _model.deleteCollaborator('1', '1');

        // verify API call is made..
        verify(_mockCollaboratorsApi.deleteCollaborator('1', '1'));
        expect(_model.stateFor(_model.deleteCOLLABORATORS), ViewState.Success);

        // verify collaborator is deleted..
        expect(
            _model.collaborators
                .where((collaborator) => _collaborator.id == collaborator.id)
                .isEmpty,
            true);
      });

      test('When called & service returns error', () async {
        var _mockCollaboratorsApi = getAndRegisterCollaboratorsApiMock();
        when(_mockCollaboratorsApi.deleteCollaborator('1', '1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProjectDetailsViewModel();
        _model.collaborators.add(_collaborator);
        await _model.deleteCollaborator('1', '1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.deleteCOLLABORATORS), ViewState.Error);
        expect(_model.errorMessageFor(_model.deleteCOLLABORATORS),
            'Some Error Occurred!');
      });
    });

    group('forkProject -', () {
      test('When called & service returns success response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.forkProject('1'))
            .thenAnswer((_) => Future.value(_project));

        var _model = ProjectDetailsViewModel();
        await _model.forkProject('1');

        // verify API call is made..
        verify(_mockProjectsApi.forkProject('1'));
        expect(_model.stateFor(_model.forkPROJECT), ViewState.Success);

        // verify forkedProject data is populated..
        expect(_model.forkedProject, _project);
      });

      test('When called & service returns error', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.forkProject('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProjectDetailsViewModel();
        await _model.forkProject('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.forkPROJECT), ViewState.Error);
        expect(
            _model.errorMessageFor(_model.forkPROJECT), 'Some Error Occurred!');
      });
    });

    group('toggleStarProject -', () {
      test('When called & service returns "Starred" response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.toggleStarProject('1'))
            .thenAnswer((_) => Future.value('Starred'));

        var _model = ProjectDetailsViewModel();
        await _model.toggleStarForProject('1');

        // verify API call is made..
        verify(_mockProjectsApi.toggleStarProject('1'));
        expect(_model.stateFor(_model.toggleSTAR), ViewState.Success);

        // verify starCount to increment by 1..
        expect(_model.starCount, 1);
      });

      test('When called & service returns "Unstarred" response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.toggleStarProject('1'))
            .thenAnswer((_) => Future.value('Unstarred'));

        var _model = ProjectDetailsViewModel();
        await _model.toggleStarForProject('1');

        // verify API call is made..
        verify(_mockProjectsApi.toggleStarProject('1'));
        expect(_model.stateFor(_model.toggleSTAR), ViewState.Success);

        // verify starCount to decrement by 1..
        expect(_model.starCount, -1);
      });

      test('When called & service returns error', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.toggleStarProject('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProjectDetailsViewModel();
        await _model.toggleStarForProject('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.toggleSTAR), ViewState.Error);
        expect(
            _model.errorMessageFor(_model.toggleSTAR), 'Some Error Occurred!');
      });
    });

    group('deleteProject -', () {
      test('When called & service returns success/true response', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.deleteProject('1'))
            .thenAnswer((_) => Future.value(true));

        var _model = ProjectDetailsViewModel();
        _model.project = _project;
        await _model.deleteProject('1');

        // verify API call is made..
        verify(_mockProjectsApi.deleteProject('1'));
        expect(_model.stateFor(_model.deletePROJECT), ViewState.Success);
      });

      test('When called & service returns error', () async {
        var _mockProjectsApi = getAndRegisterProjectsApiMock();
        when(_mockProjectsApi.deleteProject('1'))
            .thenThrow(Failure('Some Error Occurred!'));

        var _model = ProjectDetailsViewModel();
        _model.project = _project;
        await _model.deleteProject('1');

        // verify Error ViewState with proper error message..
        expect(_model.stateFor(_model.deletePROJECT), ViewState.Error);
        expect(_model.errorMessageFor(_model.deletePROJECT),
            'Some Error Occurred!');
      });
    });
  });
}
