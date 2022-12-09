import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/services/API/collaborators_api.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/services/API/grades_api.dart';
import 'package:mobile_app/services/API/group_members_api.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/services/API/ib_api.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/database_service.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/groups/add_assignment_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/assignment_details_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/edit_group_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/group_details_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/my_groups_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/new_group_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/update_assignment_viewmodel.dart';
import 'package:mobile_app/viewmodels/ib/ib_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/ib/ib_page_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_favourites_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'test_helpers.mocks.dart';

Function deepEq = const DeepCollectionEquality().equals;

class DatabaseServiceMock extends Mock implements DatabaseService {}

class GroupsApiMock extends Mock implements GroupsApi {}

class GroupMembersApiMock extends Mock implements GroupMembersApi {}

class AssignmentsApiMock extends Mock implements AssignmentsApi {}

class GradesApiMock extends Mock implements GradesApi {}

class ProjectsApiMock extends Mock implements ProjectsApi {}

class CollaboratorsApiMock extends Mock implements CollaboratorsApi {}

class IbApiMock extends Mock implements IbApi {}

class IbEngineServiceMock extends Mock implements IbEngineService {}

LocalStorageService getAndRegisterLocalStorageServiceMock() {
  _removeRegistrationIfExists<LocalStorageService>();
  var _localStorageService = MockLocalStorageService();

  locator.registerSingleton<LocalStorageService>(_localStorageService);
  return _localStorageService;
}

DatabaseService getAndRegisterDatabaseServiceMock() {
  _removeRegistrationIfExists<DatabaseService>();
  var _databaseServiceMock = DatabaseServiceMock();

  locator.registerSingleton<DatabaseService>(_databaseServiceMock);
  return _databaseServiceMock;
}

ContributorsApi getAndRegisterContributorsApiMock() {
  _removeRegistrationIfExists<ContributorsApi>();
  var _contributorsApi = MockContributorsApi();

  locator.registerSingleton<ContributorsApi>(_contributorsApi);
  return _contributorsApi;
}

GroupsApi getAndRegisterGroupsApiMock() {
  _removeRegistrationIfExists<GroupsApi>();
  var _groupsApi = GroupsApiMock();

  locator.registerSingleton<GroupsApi>(_groupsApi);
  return _groupsApi;
}

GroupMembersApi getAndRegisterGroupMembersApiMock() {
  _removeRegistrationIfExists<GroupMembersApi>();
  var _groupMembersApi = GroupMembersApiMock();

  locator.registerSingleton<GroupMembersApi>(_groupMembersApi);
  return _groupMembersApi;
}

AssignmentsApi getAndRegisterAssignmentsApiMock() {
  _removeRegistrationIfExists<AssignmentsApi>();
  var _assignmentsApi = AssignmentsApiMock();

  locator.registerSingleton<AssignmentsApi>(_assignmentsApi);
  return _assignmentsApi;
}

GradesApi getAndRegisterGradesApiMock() {
  _removeRegistrationIfExists<GradesApi>();
  var _gradesApi = GradesApiMock();

  locator.registerSingleton<GradesApi>(_gradesApi);
  return _gradesApi;
}

UsersApi getAndRegisterUsersApiMock() {
  _removeRegistrationIfExists<UsersApi>();
  var _usersApi = MockUsersApi();

  locator.registerSingleton<UsersApi>(_usersApi);
  return _usersApi;
}

ProjectsApi getAndRegisterProjectsApiMock() {
  _removeRegistrationIfExists<ProjectsApi>();
  var _projectsApi = ProjectsApiMock();

  locator.registerSingleton<ProjectsApi>(_projectsApi);
  return _projectsApi;
}

CollaboratorsApi getAndRegisterCollaboratorsApiMock() {
  _removeRegistrationIfExists<CollaboratorsApi>();
  var _collaboratorsApi = CollaboratorsApiMock();

  locator.registerSingleton<CollaboratorsApi>(_collaboratorsApi);
  return _collaboratorsApi;
}

IbApi getAndRegisterIbApiMock() {
  _removeRegistrationIfExists<IbApi>();
  var _ibApi = IbApiMock();

  locator.registerSingleton<IbApi>(_ibApi);
  return _ibApi;
}

IbEngineService getAndRegisterIbEngineServiceMock() {
  _removeRegistrationIfExists<IbEngineService>();
  var _ibEngineService = IbEngineServiceMock();

  locator.registerSingleton<IbEngineService>(_ibEngineService);
  return _ibEngineService;
}

@GenerateNiceMocks(
  [
    MockSpec<IbLandingViewModel>(),
    MockSpec<IbPageViewModel>(),
    MockSpec<UserFavouritesViewModel>(),
    MockSpec<ProjectDetailsViewModel>(),
    MockSpec<EditProfileViewModel>(),
    MockSpec<UserProjectsViewModel>(),
    MockSpec<FeaturedProjectsViewModel>(),
    MockSpec<ContributorsApi>(),
    MockSpec<UsersApi>(),
    MockSpec<EditGroupViewModel>(),
    MockSpec<MyGroupsViewModel>(),
    MockSpec<GroupDetailsViewModel>(),
    MockSpec<NewGroupViewModel>(),
    MockSpec<UpdateAssignmentViewModel>(),
    MockSpec<AddAssignmentViewModel>(),
    MockSpec<AssignmentDetailsViewModel>(),
    MockSpec<ProfileViewModel>(),
    MockSpec<DialogService>(),
    MockSpec<NavigatorObserver>(),
    MockSpec<LocalStorageService>(),
  ],
)
void registerServices() {
  getAndRegisterLocalStorageServiceMock();
  getAndRegisterDatabaseServiceMock();
  getAndRegisterContributorsApiMock();
  getAndRegisterGroupsApiMock();
  getAndRegisterGroupMembersApiMock();
  getAndRegisterAssignmentsApiMock();
  getAndRegisterGradesApiMock();
  getAndRegisterUsersApiMock();
  getAndRegisterProjectsApiMock();
  getAndRegisterCollaboratorsApiMock();
  getAndRegisterIbApiMock();
  getAndRegisterIbEngineServiceMock();
}

void unregisterServices() {
  locator.unregister<LocalStorageService>();
  locator.unregister<DatabaseService>();
  locator.unregister<ContributorsApi>();
  locator.unregister<GroupsApi>();
  locator.unregister<GroupMembersApi>();
  locator.unregister<AssignmentsApi>();
  locator.unregister<GradesApi>();
  locator.unregister<UsersApi>();
  locator.unregister<ProjectsApi>();
  locator.unregister<CollaboratorsApi>();
  locator.unregister<IbApi>();
  locator.unregister<IbEngineService>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
