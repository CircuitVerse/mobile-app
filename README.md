# CircuitVerse Mobile

[![CI](https://github.com/CircuitVerse/mobile-app/actions/workflows/ci.yml/badge.svg)](https://github.com/CircuitVerse/mobile-app/actions/workflows/ci.yml)
[![CD](https://github.com/CircuitVerse/mobile-app/actions/workflows/cd.yml/badge.svg)](https://github.com/CircuitVerse/mobile-app/actions/workflows/cd.yml)

CircuitVerse for mobile is a cross platform application built in [flutter](https://flutter.dev/) using CircuitVerse API.

## Getting Started

Follow these instructions to build and run the project

### Setup Flutter

A detailed guide for multiple platforms setup could be find [here](https://flutter.dev/docs/get-started/install/)

### Next Steps

- Clone this repository.
- `cd` into `mobile_app`.
- `flutter pub get` to get all the dependencies.
- `flutter run`

### Generating Files using Build Runner

`flutter packages pub run --no-sound-null-safety build_runner build`

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
<img src="https://user-images.githubusercontent.com/66873825/119156647-0fdb4b00-ba72-11eb-9b8f-591930ca1d85.jpg" alt="Splash View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119160372-d4428000-ba75-11eb-85ba-b4713f11a582.jpg" alt="Home View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119157561-eff85700-ba72-11eb-9ef9-7f039dba3dc1.jpg" alt="NavDrawer View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119157733-1c13d800-ba73-11eb-9808-fd4513392b86.jpg" alt="NavDrawer View Login" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119168016-18d21980-ba7e-11eb-8b2f-680e4344a191.jpg" alt="Teachers View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119168084-29828f80-ba7e-11eb-85bf-37cac4fd8807.jpg" alt="About View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119168195-47e88b00-ba7e-11eb-83d5-8cb01fc79e1b.jpg" alt="Contribute View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119168424-7f573780-ba7e-11eb-8153-968cfbbd34e9.jpg" alt="Groups View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119169086-3eabee00-ba7f-11eb-81ee-954791c57893.jpg" alt="Assignment Details View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119169235-64d18e00-ba7f-11eb-9c2a-6d199beb9cf2.jpg" alt="Assignment Date View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119169318-7d41a880-ba7f-11eb-8aee-5ca206f7d105.jpg" alt="Assignment Time View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119169369-8b8fc480-ba7f-11eb-9d22-221da88a83b2.jpg" alt="Login View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119157976-58dfcf00-ba73-11eb-843b-9adae59ae2b6.jpg" alt="Register View" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119169783-0953d000-ba80-11eb-85c7-95e50e5f6aa2.jpg" alt="Profile View" width="200">
</p>

### Dark Mode

<p>
<img src="https://user-images.githubusercontent.com/66873825/119163883-7879f600-ba79-11eb-969f-4f4403db8c62.jpg" alt="Splash View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119164824-6e0c2c00-ba7a-11eb-8640-ac869b6f7b02.jpg" alt="Home View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119164989-a1e75180-ba7a-11eb-81a5-ae143312604b.jpg" alt="Featured Circuit View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165304-fa1e5380-ba7a-11eb-880a-14e266384372.jpg" alt="About View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165323-fe4a7100-ba7a-11eb-81b7-94211ba8ed02.jpg" alt="Contribute View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165353-073b4280-ba7b-11eb-8bb5-9211f88a4339.jpg" alt="Teachers View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165521-305bd300-ba7b-11eb-879b-291fd3f7709e.jpg" alt="Groups View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165540-36ea4a80-ba7b-11eb-9bc2-1e74b7f73d8d.jpg" alt="Login View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165553-3a7dd180-ba7b-11eb-8b97-235cd93da5fb.jpg" alt="Register View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119170075-6485c280-ba80-11eb-9c24-addbd80e7865.jpg" alt="Assignment Details View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119170080-664f8600-ba80-11eb-92cb-61fcf1d82323.jpg" alt="Assignment Date View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119170084-6780b300-ba80-11eb-8c2f-0751f615f8eb.jpg" alt="Assignment Time View Dark" width="200">
<img src="https://user-images.githubusercontent.com/66873825/119165415-15895e80-ba7b-11eb-979e-f7a44a624864.jpg" alt="Profile View Dark" width="200">
</p>

## Community

We would love to hear from you! We communicate on the following platforms:

[![Slack](https://img.shields.io/badge/chat-on_slack-purple.svg?style=for-the-badge&logo=slack)](https://circuitverse.org/slack)

## Contributing

Whether you have some feauture requests/ideas, code improvements, refactoring, performance improvements, help is always Welcome. The more is done, better it gets.

If you found any bugs, consider opening an [issue](https://github.com/CircuitVerse/mobile-app/issues/new).

## License

This project is licensed under the [MIT License](LICENSE).
