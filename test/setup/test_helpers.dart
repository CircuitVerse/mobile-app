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
import 'package:mockito/mockito.dart';

Function deepEq = DeepCollectionEquality().equals;

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

class LocalStorageServiceMock extends Mock implements LocalStorageService {}

class DatabaseServiceMock extends Mock implements DatabaseService {}

class ContributorsApiMock extends Mock implements ContributorsApi {}

class GroupsApiMock extends Mock implements GroupsApi {}

class GroupMembersApiMock extends Mock implements GroupMembersApi {}

class AssignmentsApiMock extends Mock implements AssignmentsApi {}

class GradesApiMock extends Mock implements GradesApi {}

class UsersApiMock extends Mock implements UsersApi {}

class ProjectsApiMock extends Mock implements ProjectsApi {}

class CollaboratorsApiMock extends Mock implements CollaboratorsApi {}

class IbApiMock extends Mock implements IbApi {}

class IbEngineServiceMock extends Mock implements IbEngineService {}

class MockDialogService extends Mock implements DialogService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockMyGroupsViewModel extends Mock implements MyGroupsViewModel {}

class MockGroupDetailsViewModel extends Mock implements GroupDetailsViewModel {}

class MockFeaturedProjectsViewModel extends Mock
    implements FeaturedProjectsViewModel {}

class MockProjectDetailsViewModel extends Mock
    implements ProjectDetailsViewModel {}

class MockProfileViewModel extends Mock implements ProfileViewModel {}

class MockUserProjectsViewModel extends Mock implements UserProjectsViewModel {}

class MockUserFavouritesViewModel extends Mock
    implements UserFavouritesViewModel {}

class MockEditProfileViewModel extends Mock implements EditProfileViewModel {}

class MockNewGroupViewModel extends Mock implements NewGroupViewModel {}

class MockEditGroupViewModel extends Mock implements EditGroupViewModel {}

class MockAddAssignmentViewModel extends Mock
    implements AddAssignmentViewModel {}

class MockUpdateAssignmentViewModel extends Mock
    implements UpdateAssignmentViewModel {}

class MockAssignmentDetailsViewModel extends Mock
    implements AssignmentDetailsViewModel {}

class MockIbLandingViewModel extends Mock implements IbLandingViewModel {}

class MockIbPageViewModel extends Mock implements IbPageViewModel {}

LocalStorageService getAndRegisterLocalStorageServiceMock() {
  _removeRegistrationIfExists<LocalStorageService>();
  var _localStorageService = LocalStorageServiceMock();

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
  var _contributorsApi = ContributorsApiMock();

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
  var _usersApi = UsersApiMock();

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

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
