import 'package:flutter/material.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mockito/mockito.dart';

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

class LocalStorageServiceMock extends Mock implements LocalStorageService {}

class ContributorsApiMock extends Mock implements ContributorsApi {}

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

UsersApi getAndRegisterUsersApiMock() {
  _removeRegistrationIfExists<UsersApi>();
  var _usersApi = UsersApiMock();

  locator.registerSingleton<UsersApi>(_usersApi);
  return _usersApi;
}

void registerServices() {
  getAndRegisterLocalStorageServiceMock();
  getAndRegisterContributorsApiMock();
  getAndRegisterUsersApiMock();
}

void unregisterServices() {
  locator.unregister<LocalStorageService>();
  locator.unregister<ContributorsApi>();
  locator.unregister<UsersApi>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
