import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/services/API/grades_api.dart';
import 'package:mobile_app/services/API/group_members_api.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mockito/mockito.dart';

Function deepEq = DeepCollectionEquality().equals;

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

class LocalStorageServiceMock extends Mock implements LocalStorageService {}

class ContributorsApiMock extends Mock implements ContributorsApi {}

class GroupsApiMock extends Mock implements GroupsApi {}

class GroupMembersApiMock extends Mock implements GroupMembersApi {}

class AssignmentsApiMock extends Mock implements AssignmentsApi {}

class GradesApiMock extends Mock implements GradesApi {}

class UsersApiMock extends Mock implements UsersApi {}

LocalStorageService getAndRegisterLocalStorageServiceMock() {
  _removeRegistrationIfExists<LocalStorageService>();
  var _localStorageService = LocalStorageServiceMock();

  locator.registerSingleton<LocalStorageService>(_localStorageService);
  return _localStorageService;
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

void registerServices() {
  getAndRegisterLocalStorageServiceMock();
  getAndRegisterContributorsApiMock();
  getAndRegisterGroupsApiMock();
  getAndRegisterGroupMembersApiMock();
  getAndRegisterAssignmentsApiMock();
  getAndRegisterGradesApiMock();
  getAndRegisterUsersApiMock();
}

void unregisterServices() {
  locator.unregister<LocalStorageService>();
  locator.unregister<ContributorsApi>();
  locator.unregister<GroupsApi>();
  locator.unregister<GroupMembersApi>();
  locator.unregister<AssignmentsApi>();
  locator.unregister<GradesApi>();
  locator.unregister<UsersApi>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
