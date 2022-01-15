import 'package:mobile_app/enums/view_state.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/failure_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/services/API/users_api.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/viewmodels/base_viewmodel.dart';

class EditProfileViewModel extends BaseModel {
  // ViewState Keys
  String UPDATE_PROFILE = 'update_profile';

  final UsersApi _userApi = locator<UsersApi>();
  final LocalStorageService _storage = locator<LocalStorageService>();

  User? _updatedUser;

  User? get updatedUser => _updatedUser;

  set updatedUser(User? updatedUser) {
    _updatedUser = updatedUser;
    notifyListeners();
  }

  Future? updateProfile(
    String name,
    String? educationalInstitute,
    String? country,
    bool subscribed,
  ) async {
    setStateFor(UPDATE_PROFILE, ViewState.Busy);
    try {
      updatedUser = await _userApi.updateProfile(
          name, educationalInstitute, country, subscribed);
      _storage.currentUser = _updatedUser;

      setStateFor(UPDATE_PROFILE, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(UPDATE_PROFILE, ViewState.Error);
      setErrorMessageFor(UPDATE_PROFILE, f.message);
    }
  }
}
