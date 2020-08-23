import 'package:get_it/get_it.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/authentication/auth_options_viewmodel.dart';
import 'package:mobile_app/viewmodels/authentication/forgot_password_viewmodel.dart';
import 'package:mobile_app/viewmodels/authentication/login_viewmodel.dart';
import 'package:mobile_app/viewmodels/authentication/signup_viewmodel.dart';
import 'package:mobile_app/viewmodels/cv_landing_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/add_assignment_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/assignment_details_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/edit_group_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/group_details_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/my_groups_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/new_group_viewmodel.dart';
import 'package:mobile_app/viewmodels/groups/update_assignment_viewmodel.dart';
import 'package:mobile_app/viewmodels/home/home_viewmodel.dart';
import 'package:mobile_app/viewmodels/startup/startup_viewmodel.dart';
import 'package:mobile_app/viewmodels/about/about_viewmodel.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => DialogService());
  var localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);

  // API Services
  locator.registerLazySingleton<ContributorsApi>(() => HttpContributorsApi());
  locator.registerLazySingleton<UsersApi>(() => HttpUsersApi());
  locator.registerLazySingleton<GroupsApi>(() => HttpGroupsApi());
  locator.registerLazySingleton<GroupMembersApi>(() => HttpGroupMembersApi());
  locator.registerLazySingleton<AssignmentsApi>(() => HttpAssignmentsApi());
  locator.registerLazySingleton<GradesApi>(() => HttpGradesApi());
  locator.registerLazySingleton<FCMApi>(() => HttpFCMApi());

  // Startup ViewModel
  locator.registerFactory(() => StartUpViewModel());

  // Authentication ViewModels
  locator.registerFactory(() => SignupViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => AuthOptionsViewModel());
  locator.registerFactory(() => ForgotPasswordViewModel());

  // Static ViewModels
  locator.registerFactory(() => CVLandingViewModel());
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => AboutViewModel());

  // Groups ViewModels
  locator.registerFactory(() => MyGroupsViewModel());
  locator.registerFactory(() => GroupDetailsViewModel());
  locator.registerFactory(() => NewGroupViewModel());
  locator.registerFactory(() => EditGroupViewModel());

  // Assignment ViewModels
  locator.registerFactory(() => AddAssignmentViewModel());
  locator.registerFactory(() => UpdateAssignmentViewModel());
  locator.registerFactory(() => AssignmentDetailsViewModel());
}
