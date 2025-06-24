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
import 'package:mobile_app/viewmodels/profile/edit_profile_viewmodel.dart';
import 'package:mobile_app/gen_l10n/app_localizations.dart';
import '../../../config/environment_config.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

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
  final _instituteFocusNode = FocusNode();

  late TextEditingController _countryController;
  late TextEditingController _instituteController;

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _countryFocusNode.dispose();
    _instituteFocusNode.dispose();
    _countryController.dispose();
    _instituteController.dispose();
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

    _countryController = TextEditingController(text: _country ?? '');
    _instituteController = TextEditingController(
      text: _educationalInstitute ?? '',
    );

    _countryController.addListener(_onCountryChanged);
    _instituteController.addListener(_onInstituteChanged);
  }

  void _onCountryChanged() {
    final newValue = _countryController.text.trim();
    if (_country != newValue) {
      setState(() {
        _country = newValue.isEmpty ? null : newValue;
      });
    }
  }

  void _onInstituteChanged() {
    final newValue = _instituteController.text.trim();
    if (_educationalInstitute != newValue) {
      setState(() {
        _educationalInstitute = newValue.isEmpty ? null : newValue;
      });
    }
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
                      AppLocalizations.of(context)!.profile_picture,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _model.removePhoto();
                        Get.back();
                      },
                      icon: const Icon(Icons.delete, color: CVTheme.red),
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
                        padding: const EdgeInsetsDirectional.all(12.0),
                        child: Container(
                          padding: const EdgeInsetsDirectional.all(12.0),
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
              padding: const EdgeInsetsDirectional.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:
                      _model.imageUpdated
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
                padding: const EdgeInsetsDirectional.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: CVTheme.highlightText(context),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return CVTextField(
      label: AppLocalizations.of(context)!.profile_name,
      initialValue: _name,
      validator:
          (value) =>
              value?.isEmpty ?? true
                  ? AppLocalizations.of(context)!.profile_name_empty_error
                  : null,
      onSaved: (value) {
        _name = value!.trim();
      },
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_countryFocusNode);
      },
    );
  }

  Widget _buildCountryField() {
    return CVTypeAheadField(
      focusNode: _countryFocusNode,
      label: AppLocalizations.of(context)!.profile_country,
      controller: _countryController,
      toggle: CVTypeAheadField.COUNTRY,
      validator: (value) => null,
      onSaved: (value) {
        final controllerText = _countryController.text.trim();
        _country = controllerText.isEmpty ? null : controllerText;
      },
      onFieldSubmitted: () {
        _countryFocusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      action: TextInputAction.done,
      countryInstituteObject: locator<CountryInstituteAPI>(),
    );
  }

  Widget _buildInstituteField() {
    return CVTypeAheadField(
      focusNode: _instituteFocusNode,
      label: AppLocalizations.of(context)!.profile_educational_institute,
      controller: _instituteController,
      toggle: CVTypeAheadField.EDUCATIONAL_INSTITUTE,
      validator: (value) => null,
      onSaved: (value) {
        final controllerText = _instituteController.text.trim();
        _educationalInstitute = controllerText.isEmpty ? null : controllerText;
      },
      onFieldSubmitted: () {
        _instituteFocusNode.unfocus();
        FocusScope.of(context).unfocus();
      },
      action: TextInputAction.done,
      countryInstituteObject: locator<CountryInstituteAPI>(),
    );
  }

  Widget _buildSubscribedField() {
    return CheckboxListTile(
      value: _subscribed,
      title: Text(AppLocalizations.of(context)!.profile_subscribe_mails),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          _subscribed = value;
        });
      },
    );
  }

  Future<void> _validateAndSubmit() async {
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 200));

    final currentCountry = _countryController.text.trim();
    final currentInstitute = _instituteController.text.trim();

    _country = currentCountry.isEmpty ? null : currentCountry;
    _educationalInstitute = currentInstitute.isEmpty ? null : currentInstitute;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _dialogService.showCustomProgressDialog(
        title: AppLocalizations.of(context)!.profile_updating,
      );

      try {
        await _model.updateProfile(
          _name,
          _educationalInstitute,
          _country,
          _subscribed,
        );

        _dialogService.popDialog();

        if (_model.isSuccess(_model.UPDATE_PROFILE)) {
          var currentUser = locator<LocalStorageService>().currentUser!;
          currentUser.data.attributes.name = _name;
          currentUser.data.attributes.country = _country;
          currentUser.data.attributes.educationalInstitute =
              _educationalInstitute;
          currentUser.data.attributes.subscribed = _subscribed;

          await Future.delayed(const Duration(seconds: 1));
          Get.back(result: _model.updatedUser);
          SnackBarUtils.showDark(
            AppLocalizations.of(context)!.profile_updated,
            AppLocalizations.of(context)!.profile_update_success,
          );
        } else if (_model.isError(_model.UPDATE_PROFILE)) {
          SnackBarUtils.showDark(
            AppLocalizations.of(context)!.profile_update_error,
            _model.errorMessageFor(_model.UPDATE_PROFILE),
          );
        }
      } catch (e) {
        _dialogService.popDialog();
        SnackBarUtils.showDark(
          AppLocalizations.of(context)!.profile_update_error,
          AppLocalizations.of(context)!.profile_update_error,
        );
      }
    }
  }

  Widget _buildSaveDetailsButton() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: CVPrimaryButton(
        title: AppLocalizations.of(context)!.profile_save_details,
        onPressed: _validateAndSubmit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EditProfileViewModel>(
      onModelReady: (model) {
        _model = model;
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.profile_update_title),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
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
      },
    );
  }
}
