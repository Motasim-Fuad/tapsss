# TA-PASS

**Swedish citizenship language test preparation** — structured study materials, realistic practice exams, and progress tracking in one mobile app.

TA-PASS helps candidates prepare for Sweden’s citizenship language test with chapter-based lessons, timed practice tests, score history, and a readiness overview. The app is available in **English** and **Swedish**.

Current version: **1.0.5** (build 5)

---

## Download

| Store | Status | Link |
| --- | --- | --- |
| **App Store** | Live | [TA-PASS — Swedish Citizenship](https://apps.apple.com/us/app/ta-pass-swedish-citizenship/id6799644651) |
| **Google Play** | Internal testing | [Join the internal test](https://play.google.com/apps/internaltest/4701490226041425689) |

A public Play Store listing URL will be added here when the production release is published.

| Platform | Identifier |
| --- | --- |
| iOS | `com.tapass.tapassapp` |
| Android | `com.tapass.tapass` |

---

## What the app does

TA-PASS is a client for a REST backend. After onboarding and sign-in, users work through five main areas:

### Home
Dashboard with welcome state, study/test overview, and shortcuts into current progress.

### Study
Chapter-based study materials with overall completion, chapter detail, and mark-as-complete so progress is stored on the server.

### Practice tests
A list of practice exams with completed count, best score, and average score. Users can open a test, start an attempt, submit answers, view results, and review individual answers.

### Progress
Readiness tracking for the citizenship test: overview stats, test history, and score history (charts).

### Profile
Account details, language switch (English / Swedish), subscription, FAQ, Terms, Privacy Policy, logout, and account deletion.

### Auth and account
- Email/password register, OTP verification, login
- Forgot password (OTP) and reset password
- Google Sign-In and Sign in with Apple
- Secure token storage and refresh

### Subscription
In-app subscriptions via **RevenueCat** (App Store / Google Play). Plans cover premium study materials (3 months, 6 months, yearly). Entitlement identifier: `Tapass Pro`.

### Notifications
Firebase Cloud Messaging for push, with local notification display and token registration against the backend after login.

---

## Architecture

The Flutter client follows a **feature-first** layout with a light **Clean Architecture** split inside each feature:

```
lib/
  main.dart
  config/          # routes, GetX pages and bindings
  core/            # API client, interceptors, services, theme, localization
  features/        # auth, home, study, test, progress, profile, subscription, …
  shared/          # reusable widgets
```

Each feature typically contains:

| Layer | Role |
| --- | --- |
| **Presentation** | Pages, GetX controllers, bindings |
| **Domain** | Repository interfaces |
| **Data** | Remote datasources, models, repository implementations |

**GetX** handles routing (`GetMaterialApp` / `GetPage`), dependency injection (bindings), and reactive UI (`Obx`).

Networking uses **Dio** with auth and logging interceptors. Tokens live in **flutter_secure_storage** (Keychain / EncryptedSharedPreferences). Preferences (locale, onboarding) use **shared_preferences**.

---

## Flutter stack

| Area | Packages / APIs |
| --- | --- |
| SDK | Flutter, Dart `>=3.0.0 <4.0.0`, Material 3 |
| State & navigation | `get` |
| HTTP | `dio` |
| Config | `flutter_dotenv` (`.env`: API base URL, RevenueCat keys, OAuth clients) |
| Storage | `flutter_secure_storage`, `shared_preferences` |
| Auth (native) | `google_sign_in`, `sign_in_with_apple` |
| Push | `firebase_core`, `firebase_messaging`, `flutter_local_notifications` |
| IAP | `purchases_flutter` (RevenueCat) |
| UI | `cached_network_image`, `shimmer`, `percent_indicator`, `fl_chart`, `image_picker` |
| i18n | GetX `Translations` (`en_US`, `sv_SE`), `intl` |
| Links | `url_launcher` (Terms, Privacy) |
| Branding | `flutter_launcher_icons`, `flutter_native_splash` |

Firebase is used for **FCM** (and related native setup), not as the primary auth backend. Email, Google, and Apple sessions are issued by the TA-PASS API.

### Localization

UI copy is defined in `lib/core/localization/app_translations.dart`. Language can be changed from Profile and is persisted locally (and synced where the API supports it).

### Platforms

Primary targets are **iOS** and **Android**. Native work includes:

- iOS: Firebase / APNs, Google Sign-In URL scheme and client ID, Sign in with Apple, CocoaPods (including a pinned `GTMSessionFetcher` for Google Sign-In vs Firebase)
- Android: application id, Google Sign-In, Play Billing via RevenueCat

---

## Getting started

### Requirements

- Flutter SDK (stable, Dart 3)
- Xcode (iOS) / Android Studio or SDK (Android)
- A `.env` file in the project root (not committed with secrets)

### Install and run

```bash
flutter pub get
cd ios && pod install && cd ..
flutter run
```

Point `API_BASE_URL` in `.env` at the environment you are using (local machine LAN IP on a physical device — `localhost` is the phone itself).

Typical `.env` keys (values are environment-specific):

- `API_BASE_URL`
- `REVENUECAT_IOS_API_KEY`
- `REVENUECAT_ANDROID_API_KEY`
- Google OAuth client IDs used by the native sign-in plugins

Do not commit production keys. If `.env` was tracked historically, keep it out of new commits (`git rm --cached .env`).

### Useful commands

```bash
flutter analyze
flutter build ios
flutter build appbundle
```

---

## Product notes

- Study content, tests, and progress are loaded from the backend; the app does not ship the full curriculum as static assets.
- Purchase UX is client-side via RevenueCat; App Store Connect / Play Console products must match the identifiers used in the subscription controller.
- Legal pages (Terms, Privacy) open in the system browser.

---

## License

Private / proprietary. All rights reserved.
