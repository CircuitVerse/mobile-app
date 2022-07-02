import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/API/country_institute_api.dart';
import 'package:mobile_app/services/dialog_service.dart';
import 'package:mobile_app/services/local_storage_service.dart';
import 'package:mobile_app/ui/components/cv_primary_button.dart';
import 'package:mobile_app/ui/components/cv_text_field.dart';
import 'package:mobile_app/ui/components/cv_typeahead_field.dart';
import 'package:mobile_app/ui/views/base_view.dart';
import 'package:mobile_app/utils/snackbar_utils.dart';
import 'package:mobile_app/utils/validators.dart';
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';

import '../../../config/environment_config.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  static const String id = 'edit_profile_view';

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final DialogService _dialogService = locator<DialogService>();
  late EditProfileViewModel _model;
  final _formKey = GlobalKey<FormState>();
  late String _name, _profilePicture;
  String? _educationalInstitute, _country;
  late bool _subscribed;

  final _nameFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _countryFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var _userAttrs =
        locator<LocalStorageService>().currentUser!.data.attributes;
    _name = _userAttrs.name!;
    _educationalInstitute = _userAttrs.educationalInstitute;
    _country = _userAttrs.country;
    _subscribed = _userAttrs.subscribed;
    _profilePicture = _userAttrs.profilePicture ?? 'Default';
  }

  Widget _buildProfilePicture() {
    final imageURL = EnvironmentConfig.CV_BASE_URL + _profilePicture;
    return GestureDetector(
      key: const Key('profile_image'),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      'Profile Picture',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _model.removePhoto();
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: CVTheme.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: List.generate(2, (index) {
                    return GestureDetector(
                      onTap: () {
                        _model.pickProfileImage(index);
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: CVTheme.grey),
                          ),
                          child: Icon(
                            index == 0 ? Icons.camera_alt : Icons.collections,
                            color: CVTheme.primaryColor,
                            size: 30,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
      child: Center(
        child: Stack(
          children: [
            Container(
              height: 120,
              width: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _model.imageUpdated
                      ? FileImage(_model.updatedImage!)
                      : imageURL.toLowerCase().contains('default') ||
                              _model.removeImage
                          ? const AssetImage(
                              'assets/images/profile/default_icon.jpg',
                            )
                          : NetworkImage(imageURL) as ImageProvider,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CVTheme.highlightText(context),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return CVTextField(
      label: 'Name',
      initialValue: _name,
      validator: (value) =>
          value?.isEmpty ?? true ? "Name can't be empty" : null,
      onSaved: (value) => _name = value!.trim(),
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_nameFocusNode),
    );
  }

  Widget _buildCountryField() {
    return CVTypeAheadField(
      focusNode: _nameFocusNode,
      label: 'Country',
      controller: TextEditingController(text: _country),
      onSaved: (value) => _country = (value != '') ? value!.trim() : '',
      onFieldSubmitted: () {
        _nameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_countryFocusNode);
      },
      toggle: CVTypeAheadField.COUNTRY,
      countryInstituteObject: locator<CountryInstituteAPI>(),
    );
  }

  Widget _buildInstituteField() {
    return CVTypeAheadField(
      focusNode: _countryFocusNode,
      label: 'Educational Institute',
      controller: TextEditingController(text: _educationalInstitute),
      onSaved: (value) =>
          _educationalInstitute = (value != '') ? value!.trim() : '',
      toggle: CVTypeAheadField.EDUCATIONAL_INSTITUTE,
      action: TextInputAction.done,
      countryInstituteObject: locator<CountryInstituteAPI>(),
    );
  }

  Widget _buildSubscribedField() {
    return CheckboxListTile(
      value: _subscribed,
      title: const Text('Subscribe to mails?'),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _subscribed = value;
        });
      },
    );
  }

  Future<void> _validateAndSubmit() async {
    if (Validators.validateAndSaveForm(_formKey)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _dialogService.showCustomProgressDialog(title: 'Updating..');

      await _model.updateProfile(
          _name, _educationalInstitute, _country, _subscribed);

      _dialogService.popDialog();

      if (_model.isSuccess(_model.UPDATE_PROFILE)) {
        await Future.delayed(const Duration(seconds: 1));
        Get.back(result: _model.updatedUser);
        SnackBarUtils.showDark(
          'Profile Updated',
          'Your profile was successfully updated.',
        );
      } else if (_model.isError(_model.UPDATE_PROFILE)) {
        SnackBarUtils.showDark(
          'Error',
          _model.errorMessageFor(_model.UPDATE_PROFILE),
        );
      }
    }
  }

  Widget _buildSaveDetailsButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CVPrimaryButton(
        title: 'Save Details',
        onPressed: _validateAndSubmit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileViewModel>(
      onModelReady: (model) => _model = model,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: const Text('Update Profile')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildProfilePicture(),
                const SizedBox(height: 20),
                _buildNameInput(),
                _buildCountryField(),
                _buildInstituteField(),
                _buildSubscribedField(),
                const SizedBox(height: 16),
                _buildSaveDetailsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
