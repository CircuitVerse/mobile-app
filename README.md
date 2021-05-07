# CircuitVerse Mobile

[![CI](https://github.com/CircuitVerse/mobile-app/actions/workflows/ci.yml/badge.svg)](https://github.com/CircuitVerse/mobile-app/actions/workflows/ci.yml)
[![CD](https://github.com/CircuitVerse/mobile-app/actions/workflows/cd.yml/badge.svg)](https://github.com/CircuitVerse/mobile-app/actions/workflows/cd.yml)

CircuitVerse for mobile is a cross platform appication built in [flutter](https://flutter.dev/) using CircuitVerse API.

## Getting Started

Follow these instructions to build and run the project

### Setup Flutter

A detailed guide for multiple platforms setup could be find [here](https://flutter.dev/docs/get-started/install/)

### Next Steps

- Clone this repository.
- `cd` into `mobile_app`.
- `flutter pub get` to get all the dependencies.
- `flutter run`

### Android OAuth Config

This project uses flutter version 1.20.2 and hence the support for compile time variables. To use compile time variables pass them in `--dart-defines` as `flutter run --dart-define=VAR_NAME=VAR_VALUE`. Supported `dart-defines` include :

#### Facebook Configuration

1. `FB_APP_ID`

#### Github Configuration

1. `GITHUB_OAUTH_CLIENT_ID`
2. `GITHUB_OAUTH_CLIENT_SECRET`

#### Google Configuration

For Google OAuth we use [google_sign_in](https://pub.dev/packages/google_sign_in). You'll require a Java KeyStore(`.jks`)

1. Add `cv_debug.jks` in `android/app/`.
2. Add `key.debug.properties` in `android/`.

Note: The OAuth Configuration section is not mandatory to get started. To get hold of the above secrets/files drop a message on slack with clear requirements and we'll take care.

## Project Structure

```bash
mobile-app/lib/
├── config/                         # configuration files like environment_config
├── enums/                          # enum files
|   └── view_state.dart             # defines view states i.e Idle, Busy, Error
|   └── auth_state.dart             # defines auth states i.e logged in using Google/FB/Github/Email
├── l10n/                           # localization files like intl_en.arb
├── locale/                         # AppLocalization & AppLocalizationDelegate
├── managers/
|   └── dialog_manager.dart         # show dialogs using dialog navigation key
├── models/                         # model classes
|   └── dialog_models.dart          # dialog request and response models
        ...
├── services/                       # services
|   ├── API/                        # API implementations
|   └── dialog_service.dart         # handles dialog
|   └── local_storage_service.dart  # handles local storage (shared prefs)
├── ui/                             # UI layer
|  ├── views/                       # views
|  |  └── base_view.dart
|  |  └── cv_landing_view.dart
|  |  └── startup_view.dart
|  └── components/                  # shared components
├── utils/                          # utilities such as api_utils routes.dart and styles.dart
├── viewmodels/                     # Viewmodels layer
├── app_theme.dart                  # Shared App Colors/border decorations etc.
├── constants.dart                  # App constants
├── locator.dart                    # dependency injection using get_it
├── main.dart                       # <3 of the app
```

## Features

### Groups

- Create Groups.
- Edit/Update/Delete Groups.
- Add/Delete Members to the group.

### Assignments

- Create/Add Assignment to a Group.
- Edit Assignments.
- Check Assignment Submissions.
- Grade Assignment's projects.
- Update/Delete Grades.

### Projects/Circuits

- Fork Project.
- Edit/Delete Project.
- Add/Delete Collaborators.
- Star Project to favourites.
- View Projects you created/starred.

### Profile

- View/Edit Profile

## Screenshots

<p>
<img src="https://user-images.githubusercontent.com/45434030/90981168-2903a980-e57d-11ea-9f77-a991d3e2d7f5.jpg" alt="Splash View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981130-feb1ec00-e57c-11ea-8af5-6a8e30d85e60.jpg" alt="Home View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981154-14bfac80-e57d-11ea-82b7-36e713a0f205.jpg" alt="NavDrawer View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981181-39b41f80-e57d-11ea-9b48-a456667bcd70.jpg" alt="Teachers View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981063-8a774880-e57c-11ea-93ba-e51c2a8d05bb.jpg" alt="About View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981111-e0e48700-e57c-11ea-840e-eab6d05249ad.jpg" alt="Contribute View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981115-eb9f1c00-e57c-11ea-8ebf-de496e0492e6.jpg" alt="Group Details View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981121-f5288400-e57c-11ea-9909-7c5d860c6246.jpg" alt="Groups View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981081-b5fa3300-e57c-11ea-9abb-4b76957bb7cb.jpg" alt="Assignment Details View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981091-c1e5f500-e57c-11ea-879e-edc915c3ae70.jpg" alt="Assignment Date View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981096-cca08a00-e57c-11ea-8bc9-beed9c665763.jpg" alt="Assignment Time View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981141-08d3ea80-e57d-11ea-8914-34dcce839a0b.jpg" alt="Login View" width="200">
<img src="https://user-images.githubusercontent.com/45434030/90981159-1ee1ab00-e57d-11ea-8fa5-4a7d54de175f.jpg" alt="Profile View" width="200">
</p>

## Community

We would love to hear from you! We communicate on the following platforms:

[![Slack](https://img.shields.io/badge/chat-on_slack-purple.svg?style=for-the-badge&logo=slack)](https://circuitverse.org/slack)

## Contributing

Whether you have some feauture requests/ideas, code improvements, refactoring, performance improvements, help is always Welcome. The more is done, better it gets.

If you found any bugs, consider opening an [issue](https://github.com/CircuitVerse/mobile-app/issues/new).

## License

This project is licensed under the [MIT License](LICENSE).
