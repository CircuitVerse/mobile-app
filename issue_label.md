# Issue & PR Label Guide

This document defines the labeling system used for issues and pull requests in the **mobile-app** repository. The goal is to ensure consistent triaging, improve issue clarity, and make it easier for contributors and maintainers to collaborate effectively.

Labels are applied after verifying reproducibility, checking for duplicates, and ensuring each issue addresses a single concern. Issues covering multiple concerns may be split for clarity.

---

## Status Labels

These labels represent the **current lifecycle state** of an issue.

| Label         | Description                                                            |
| ------------- | ---------------------------------------------------------------------- |
| `pending`     | Issue has been reported and is awaiting initial triage.                |
| `in progress` | Work on the issue has started.                                         |
| `blocked`     | Progress is blocked due to a dependency or external factor.            |
| `duplicate`   | The issue has already been reported and is tracked elsewhere.          |
| `stale`       | No activity for an extended period; may be closed if no updates occur. |

---

## Type Labels

These labels describe **the nature of the issue**.

| Label             | Description                                                              |
| ----------------- | ------------------------------------------------------------------------ |
| `bug`             | Something is broken or not functioning as intended.                      |
| `feature`         | Request for new functionality or capability.                             |
| `enhancement`     | Improvement to an existing feature or behavior.                          |
| `documentation`   | Issues related to documentation, guides, or comments.                    |
| `ui/ux`           | User interface or user experience-related issues.                        |
| `security`        | Issues that may impact application or user security.                     |
| `breaking change` | Changes that may break existing functionality or backward compatibility. |

---

## Platform Labels

These labels indicate **where the issue applies**.

| Label      | Description                                           |
| ---------- | ----------------------------------------------------- |
| `flutter`  | Issues related to the Flutter framework.             |
| `android`  | Android-specific functionality or behavior.          |
| `ios`      | iOS-specific functionality or behavior.              |
| `web`      | Web-specific functionality when running Flutter web. |

---

## Operating System Labels

Used when an issue is **OS-specific**.

| Label     | Description                             |
| --------- | --------------------------------------- |
| `windows` | Issue specific to Windows environments. |
| `linux`   | Issue specific to Linux environments.   |
| `macos`   | Issue specific to macOS environments.   |

---

## Contributor-Friendly Labels

These labels help contributors discover suitable issues.

| Label              | Description                                      |
| ------------------ | ------------------------------------------------ |
| `good first issue` | Suitable for first-time contributors.            |
| `help wanted`      | Maintainers welcome contributions on this issue. |

---

## Time-Based Labels

These labels indicate **estimated effort or scope**.

| Label    | Description                                                 |
| -------- | ----------------------------------------------------------- |
| `small`  | Minor change, quick fix, or low-risk update.                |
| `medium` | Requires moderate changes or understanding of the codebase. |
| `large`  | Significant refactor, complex logic, or multi-file changes. |

---

## Pull Request Labels

### PR Status

| Label          | Description                                                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `review-ready` | Pull request is ready for review. This is added only after all the threads mentioned by CodeRabbit and reviewers have been addressed. |
| `approved`     | Pull request has been reviewed and approved.                                                                                          |

### PR Priority

| Label | Description                                 |
| ----- | ------------------------------------------- |
| `p0`  | Critical fix; requires immediate attention. |
| `p1`  | High priority but not blocking.             |
| `p2`  | Normal priority.                            |

---

## Flutter-Specific Labels

Additional labels for Flutter mobile development.

| Label          | Description                                    |
| -------------- | ---------------------------------------------- |
| `dart`         | Issues related to Dart language features.     |
| `state-mgmt`   | State management related issues.               |
| `navigation`   | Navigation and routing related issues.         |
| `performance`  | Performance optimization issues.               |
| `localization` | Internationalization and localization issues. |
| `testing`      | Unit, widget, or integration testing issues.  |