import 'package:get_it/get_it.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/API/contributors_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
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

  // Startup ViewModel
  locator.registerFactory(() => StartUpViewModel());

  // Static ViewModels
  locator.registerFactory(() => HomeViewModel());
  locator.registerFactory(() => AboutViewModel());
}
