import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  final ImageCropper _cropper = ImageCropper();

  bool imageUpdated = false, removeImage = false;
  File? updatedImage;

  User? _updatedUser;

  User? get updatedUser => _updatedUser;

  set updatedUser(User? updatedUser) {
    _updatedUser = updatedUser;
    notifyListeners();
  }

  void pickProfileImage(int index) async {
    removeImage = false;
    final _image = await _picker.pickImage(
      source: index == 0 ? ImageSource.camera : ImageSource.gallery,
    );

    if (_image == null) return;

    final _croppedImage = await _cropper.cropImage(
      sourcePath: _image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,
    );

    if (_croppedImage == null) return;

    imageUpdated = true;
    updatedImage = File(_croppedImage.path);
    notifyListeners();
  }

  void removePhoto() {
    removeImage = true;
    imageUpdated = false;
    updatedImage = null;
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
      updatedUser = await _userApi.updateProfile(name, educationalInstitute,
          country, subscribed, updatedImage, removeImage);
      _storage.currentUser = _updatedUser;

      setStateFor(UPDATE_PROFILE, ViewState.Success);
    } on Failure catch (f) {
      setStateFor(UPDATE_PROFILE, ViewState.Error);
      setErrorMessageFor(UPDATE_PROFILE, f.message);
    }
  }
}
