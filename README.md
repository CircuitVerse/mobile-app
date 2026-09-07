# CircuitVerse Mobile

[![CI](https://github.com/CircuitVerse/mobile-app/actions/workflows/ci.yml/badge.svg)](https://github.com/CircuitVerse/mobile-app/actions/workflows/ci.yml)
[![CD](https://github.com/CircuitVerse/mobile-app/actions/workflows/cd.yml/badge.svg)](https://github.com/CircuitVerse/mobile-app/actions/workflows/cd.yml)

CircuitVerse for mobile is a cross-platform application built in [Flutter](https://flutter.dev/) using CircuitVerse API.

## Getting Started

Follow these instructions to build and run the project

### Prerequisites

- Flutter `3.44.0` (stable) — the version CI builds against
- Dart `3.12` (bundled with Flutter)

> Tip: To ensure you’re always using the correct Flutter version, consider using [FVM (Flutter Version Manager)](https://fvm.app/) to manage versions.

### Setup Flutter

A detailed guide for multiple platforms setup can be found [in the Flutter installation guide](https://docs.flutter.dev/get-started/install)

### Setup Project

- Clone this repository using `git clone https://github.com/CircuitVerse/mobile-app.git`.
- `cd` into `mobile_app`.
- `flutter pub get` to get all the dependencies.
- Generate files using Builder Runner (**required**) 
```
flutter pub run build_runner build --delete-conflicting-outputs
```
- Switch to mobile-app's git hooks (**optional but recommended**)
```
git config core.hooksPath .githooks/

# Make sure npm is installed to run the next command
npm install -g @commitlint/config-conventional @commitlint/cli
```
> Mobile App enforces [Conventional Commits specification](https://www.conventionalcommits.org/en/v1.0.0/), make sure to read and follow them.

### Running the app

Make sure you have a connected Android/iOS device/simulator and run the following command to build and run the app in debug mode.

`flutter run`

#### Running on Chrome (Web)

To run the app on Chrome, use:

`flutter run -d chrome`

> **Note:** When running on Chrome locally, all API calls to `circuitverse.org` will be blocked by the browser's **CORS policy**. This causes Login, Register, and all data loading to fail. To bypass this during local development, launch Chrome with the `--disable-web-security` flag:

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

> ⚠️ Only use `--disable-web-security` for **local development**. Never use it in production.

### Compile-time Configuration

This project uses Flutter 3.44.0 and hence the support for compile-time variables. To use compile-time variables pass them in `--dart-defines` as `flutter run --dart-define=VAR_NAME=VAR_VALUE`. Supported `dart-defines` include :

#### API Configuration

Both hosts default to production, so no configuration is needed to get started.

| Variable | Default | Used for |
| --- | --- | --- |
| `CV_API_BASE_URL` | `https://circuitverse.org/api/v1` | CircuitVerse REST API |
| `IB_API_BASE_URL` | `https://learn.circuitverse.org/api` | Interactive Book content API |

To point the Interactive Book at a backend running locally:

```bash
flutter run --dart-define=IB_API_BASE_URL=http://localhost:8000/api
```

### Android OAuth Config

#### GitHub Configuration

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
├── controllers/                    # GetX controllers
|   └── language_controller.dart    # active locale
├── data/                           # static data tables
├── enums/                          # enum files
|   └── view_state.dart             # defines view states i.e Idle, Busy, Error
|   └── auth_state.dart             # defines auth states i.e logged in using Google/Github/Email
├── features/                       # self-contained features
|   └── interactive-book/           # Interactive Book (see Features below)
|      ├── models/                  # content API models, one per widget type
|      ├── services/                # API, chapters, navbar, offline cache, progress
|      ├── ui/                      # home, navbar, renderer and content widgets
|      └── root.dart                # entry point and navigation state
├── gen_l10n/                       # generated localizations (flutter gen-l10n)
├── l10n/                           # localization files like app_en.arb
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
├── cv_theme.dart                   # Shared App Colors/border decorations etc.
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

### Interactive Book

A guided digital logic course, rendered from a structured content API rather than
bundled with the app.

- Browse chapters and topics from a drawer that tracks reading progress.
- Progress is stored on the device, so the home screen can resume at the next unread topic.
- Download the whole book for offline reading, and clear it again from the same card.
- Work through interactive widgets: a binary simulator, bitwise operators, logic gate
  switches, character encoding, and inline pop quizzes.
- Content is served from `IB_API_BASE_URL`, with chapter pages addressed by slug.
  Requests prefer the network and fall back to the offline cache.

### Profile

- View/Edit Profile

### Multi-language Support

- English
- Hindi
- Arabic

## Screenshots

<p>
<img src="https://github.com/user-attachments/assets/e5269288-f5a6-4e49-900f-3c510db36df4" alt="Splash View" width="200">
<img src="https://github.com/user-attachments/assets/73e374d4-e9e9-4d47-af9a-43757b7d7bd5" alt="Home View" width="200">
<img src="https://github.com/user-attachments/assets/98624460-b1b1-444e-a8c3-3558fe86a908" alt="NavDrawer View" width="200">
<img src="https://github.com/user-attachments/assets/aedc23a6-0420-41ed-bfa2-e98801f5d947" alt="NavDrawer View Login" width="200">
<img src="https://github.com/user-attachments/assets/45f8b4b7-8604-4d68-95eb-c1f9a467d3ae" alt="Teachers View" width="200">
<img src="https://github.com/user-attachments/assets/7f319a5a-1c62-41b1-af56-3ceef3715963" alt="About View" width="200">
<img src="https://github.com/user-attachments/assets/a08c6e70-80ab-47e1-8973-1c80620e477c" alt="Contribute View" width="200">
<img src="https://github.com/user-attachments/assets/1dc6bb6d-ae37-46f4-9810-b6e6fdaf6233" alt="Groups View" width="200">
<img src="https://github.com/user-attachments/assets/7ed636d5-996b-4883-8141-ff31881f37e9" alt="Assignment Details View" width="200">
<img src="https://github.com/user-attachments/assets/5ade9bd2-e0a7-44e8-bd83-5beb975ac852" alt="Assignment Date View" width="200">
<img src="https://github.com/user-attachments/assets/a11bed45-d54d-4305-8c90-7e5682d5b941" alt="Assignment Time View" width="200">
<img src="https://github.com/user-attachments/assets/7d66e4bb-77fb-462a-b972-a905603b6b06" alt="Login View" width="200">
<img src="https://github.com/user-attachments/assets/1183b5a8-1745-456e-aced-5acced8ebfeb" alt="Register View" width="200">
<img src="https://github.com/user-attachments/assets/135c115f-5739-41d2-8ddb-641935fc2047" alt="Profile View" width="200">
<img src="https://github.com/user-attachments/assets/85a02088-8b6d-43fa-ad17-560158481685" alt="Featured Circuits" width="200">
<img src="https://github.com/user-attachments/assets/3eeed6f8-88f2-47b5-a9b5-633abd83ee9c" alt="Exit Page" width="200">
</p>

### Simulator

<p>
<img src="https://github.com/user-attachments/assets/7a9b4796-6296-4099-bdb5-2b02b567daf4" alt="Simulator" height="375">       
</p>

### Multilingual Support

<p>
<img src="https://github.com/user-attachments/assets/73e374d4-e9e9-4d47-af9a-43757b7d7bd5" alt="English" width="200">
<img src="https://github.com/user-attachments/assets/bfdfca57-79f5-4bc4-a5f2-49cca7a7427d" alt="Hindi" width="200">
<img src="https://github.com/user-attachments/assets/757620f7-ef44-465c-a9f1-1b3087e8a416" alt="Arabic" width="200">       
</p>

### Dark Mode

<p>
<img src="https://github.com/user-attachments/assets/e596dac9-29ef-4510-a3f0-4b8726f57435" alt="Splash View Dark" width="200">
</p>

## Community

We would love to hear from you! We communicate on the following platforms:

[![Slack](https://img.shields.io/badge/chat-on_slack-purple.svg?style=for-the-badge&logo=slack)](https://circuitverse.org/slack)

## Contributing

Whether you have feature requests/ideas, code improvements, refactoring, performance improvements, help is always welcome. The more contributions, the better it gets.

If you found any bugs, consider opening an [issue](https://github.com/CircuitVerse/mobile-app/issues/new).

## Contributors

<a href="https://github.com/CircuitVerse/mobile-app/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=CircuitVerse/mobile-app" alt="CircuitVerse Mobile App Contributors" />
</a>

## License

This project is licensed under the [MIT License](LICENSE).
