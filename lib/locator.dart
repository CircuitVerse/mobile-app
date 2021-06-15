import 'package:get_it/get_it.dart';
import 'package:mobile_app/services/API/assignments_api.dart';
import 'package:mobile_app/services/API/collaborators_api.dart';
import 'package:mobile_app/services/API/fcm_api.dart';
import 'package:mobile_app/services/API/grades_api.dart';
import 'package:mobile_app/services/API/group_members_api.dart';
import 'package:mobile_app/services/API/groups_api.dart';
import 'package:mobile_app/services/API/ib_api.dart';
import 'package:mobile_app/services/API/projects_api.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/API/country_institute_api.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/services/ib_engine_service.dart';
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
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/profile_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_favourites_viewmodel.dart';
import 'package:mobile_app/viewmodels/profile/user_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/edit_project_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/featured_projects_viewmodel.dart';
import 'package:mobile_app/viewmodels/projects/project_details_viewmodel.dart';
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
  locator.registerLazySingleton<ProjectsApi>(() => HttpProjectsApi());
  locator.registerLazySingleton<CollaboratorsApi>(() => HttpCollaboratorsApi());
  locator.registerLazySingleton<GroupsApi>(() => HttpGroupsApi());
  locator.registerLazySingleton<GroupMembersApi>(() => HttpGroupMembersApi());
  locator.registerLazySingleton<AssignmentsApi>(() => HttpAssignmentsApi());
  locator.registerLazySingleton<GradesApi>(() => HttpGradesApi());
  locator.registerLazySingleton<FCMApi>(() => HttpFCMApi());
  locator.registerLazySingleton<CountryInstituteAPI>(
      () => HttpCountryInstituteAPI());
  locator.registerLazySingleton<IbApi>(() => HttpIbApi());

  // Interactive Book Engine Service
  locator.registerLazySingleton<IbEngineService>(() => IbEngineServiceImpl());

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

  // Profile ViewModels
  locator.registerFactory(() => ProfileViewModel());
  locator.registerFactory(() => EditProfileViewModel());
  locator.registerFactory(() => UserProjectsViewModel());
  locator.registerFactory(() => UserFavouritesViewModel());

  // Project ViewModels
  locator.registerFactory(() => FeaturedProjectsViewModel());
  locator.registerFactory(() => ProjectDetailsViewModel());
  locator.registerFactory(() => EditProjectViewModel());

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
