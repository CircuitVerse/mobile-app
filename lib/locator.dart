import 'package:get_it/get_it.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/services/navigation_service.dart';
import 'package:mobile_app/viewmodels/home_viewmodel.dart';
import 'package:mobile_app/viewmodels/login_viewmodel.dart';
import 'package:mobile_app/viewmodels/startup_viewmodel.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  var localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);

  locator.registerFactory(() => StartUpViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => HomeViewModel());
}
