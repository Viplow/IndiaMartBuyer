# B2B Marketplace — Walkthrough & Production Guide

This document explains how the app works and how to take it to production. The project is **Android and iOS only** (web, Windows, macOS, and Linux folders have been removed).

---

## 1. How the app works

### 1.1 Entry point and startup

1. **`main.dart`**
   - Calls `WidgetsFlutterBinding.ensureInitialized()` (required before any async or plugin use).
   - Calls **`registerSDUIWidgets()`** so all Server-Driven UI components are registered before any screen can be loaded from JSON.
   - Runs the app with **`B2BMarketplaceApp`**, which sets the theme and **`ListingPage`** as the home screen.

2. **SDUI bootstrap (`lib/core/sdui/sdui_bootstrap.dart`)**
   - Registers widget types the server can reference in JSON:
     - **`ListingCard`** — Renders a single listing from JSON attributes.
     - **`EmptyState`** — Shown when there are no results.
     - **`ListingScreen`** — Full listing page (can take `listings`, `empty`, `skeleton` in attributes).
     - **`CompanyScreen`** — Full company page (takes optional `profile` JSON).
   - When you load a screen from JSON (e.g. via `SDUIScreenLoader`), the registry looks up the `type` and builds the corresponding widget with the given attributes.

### 1.2 Listing flow (Listing Page)

1. **`ListingPage`** (`lib/features/listing/listing_page.dart`)
   - Can run in three modes (controlled by constructor or SDUI payload):
     - **Normal:** Loads listings from `MockData.listings` (or from SDUI `listings` attribute), then shows the grid.
     - **Skeleton:** `useSkeleton: true` — Shows shimmer placeholders for cards for ~800 ms, then switches to real data (or empty).
     - **Empty:** `emptyState: true` — Shows the empty state with “Refresh” CTA.
   - **Sticky filter bar** at the top: chips (Price, MOQ, Location, Supplier Type) and a sort dropdown (Relevance, Price: Low to High, Verified Suppliers). Chips and sort are local state; you can later wire them to API query params.
   - **Grid:** 2 columns of **`ListingCard`** widgets. Each card shows image, title, price range, MOQ, supplier name (with verified badge), location, and buttons: “Contact Supplier” and “Get Best Price”.
   - Tapping a card **navigates to `CompanyPage`** with a company profile (currently from `MockData.companyProfile`). In production, you’d pass the profile for that supplier (e.g. from API or from listing payload).

2. **Data**
   - Listings and company data live in **`lib/data/mock_data.dart`**. Models: **`ListingItem`** (`lib/data/models/listing_item.dart`) and **`CompanyProfile`** / **`CompanyProduct`** (`lib/data/models/company.dart`). Replace mock data with API calls when moving to production.

### 1.3 Company flow (Company Page)

1. **`CompanyPage`** (`lib/features/company/company_page.dart`)
   - Receives a **`CompanyProfile`** (from navigation or SDUI).
   - **Hero:** Full-width banner image, overlaid logo, name, verified badge, tagline, trust chips (years, rating, certifications), and CTAs: Contact Company, Get Best Price, Follow.
   - **Tabs:** Products | Gallery | About | Reviews (sticky under the hero).
   - **Products tab:** Grid of **`CompanyProductCard`** (image, name, price, MOQ, “Get Best Price”).
   - **Gallery tab:** Horizontal list of images from `profile.galleryUrls`.
   - **About tab:** `profile.about` and location.
   - **Reviews tab:** Placeholder for future implementation.

### 1.4 SDUI (Server-Driven UI)

- **Purpose:** The server can send JSON that describes which screen to show and with what data, so you can change layouts or content without an app release.
- **Schema:** Each node has `type`, `attributes`, and optional `children`. See **`SDUINode`** in `lib/core/sdui/sdui_schema.dart`.
- **Rendering:** **`SDUIRegistry`** maps `type` to a builder. **`SDUIRenderer.build(context, node)`** (or the registry directly) turns a node into a widget.
- **Loading a screen from JSON:**
  - Use **`SDUIScreenLoader`** (`lib/core/sdui/sdui_screen_loader.dart`):
    - **`assetPath`** — e.g. `'assets/sdui/listing_screen.json'` to load from app assets.
    - **`jsonFuture`** — e.g. `http.get(uri).then((r) => jsonDecode(r.body))` to load from your API.
  - Example JSON for the listing screen is in **`assets/sdui/listing_screen.json`** (`type: "ListingScreen"`, optional `empty` / `skeleton`). For company, you’d use `type: "CompanyScreen"` and pass `profile` in attributes.
- **Extending:** To add a new server-driven screen or component, register it in `sdui_bootstrap.dart` and (if needed) add a new widget under `lib/features/` or `lib/core/sdui/widgets/`.

### 1.5 Design system

- **Theme:** **`AppTheme.light`** in `lib/core/theme/app_theme.dart` (used in `main.dart`).
- **Colors:** `lib/core/theme/app_colors.dart` (background, surface, text, accent, verified green, etc.).
- **Typography:** `lib/core/theme/app_typography.dart` (Inter via Google Fonts).
- **Spacing / decorations:** `app_spacing.dart`, `app_decorations.dart` (cards, chips, shadows). Use these across features for a consistent, production-ready look.

---

## 2. Running the app (Android & iOS only)

### 2.1 Prerequisites

- Flutter SDK installed and on PATH.
- Android Studio (or Android SDK) for Android.
- Xcode (macOS only) for iOS.
- For iOS: CocoaPods (`sudo gem install cocoapods` on macOS).

### 2.2 Commands

```bash
# From project root
flutter pub get
flutter run
```

- **Android:** Connect a device or start an emulator, then `flutter run` (or choose device from IDE).
- **iOS (macOS only):** Open `ios/Runner.xcworkspace` in Xcode if needed, then `flutter run` or run from Xcode.

To build release artifacts:

```bash
# Android: outputs .aab or .apk
flutter build apk        # APK for direct install / testing
flutter build appbundle  # AAB for Play Store

# iOS (macOS only)
flutter build ios
# Then archive and upload from Xcode or use fastlane / CI.
```

---

## 3. Moving to production

### 3.1 Environment and configuration

- **Base URL / API keys:** Do not hardcode. Use either:
  - **`--dart-define`** at build time, e.g.  
    `flutter build apk --dart-define=API_BASE=https://api.yourcompany.com`
  - Or a config file (e.g. `assets/config.json`) that is **not** committed with production URLs/keys; inject it in CI from secrets.
- **App config class:** Create e.g. `lib/core/config/app_config.dart` that reads `String.fromEnvironment('API_BASE', defaultValue: '')` (or your JSON) and exposes base URL, feature flags, etc. Use this in your API client.

### 3.2 Replacing mock data with APIs

1. **Listings**
   - Add an API client (e.g. `lib/data/api/` or `lib/data/repositories/listing_repository.dart`).
   - `ListingPage` (or a controller/bloc) should call the API with query params (filters, sort, pagination).
   - Map API response to `ListingItem` (or extend the model if needed). Pass the list into the page or via SDUI `listings` attribute.
   - Keep skeleton/empty behavior: show skeletons while loading; show empty state when the list is empty.

2. **Company profile**
   - Add an endpoint like `GET /suppliers/:id` (or similar) returning company + products + gallery.
   - Map response to `CompanyProfile` / `CompanyProduct`. When user taps a listing card, navigate with `supplierId`, then fetch profile (or pass from listing if already embedded).
   - Optionally cache company profiles (e.g. in memory or with a simple cache package) to avoid refetch on back.

3. **SDUI in production**
   - Serve screen JSON from your backend (e.g. `GET /app/screens/home`).
   - Use **`SDUIScreenLoader(jsonFuture: yourApi.getScreen('home'))`** as the home (or a tab) instead of hardcoding `ListingPage()`.
   - Ensure JSON schema versioning and backward compatibility so old app versions don’t break when you add new attributes.

### 3.3 Security and best practices

- Use **HTTPS** only for all API and SDUI endpoints.
- Store tokens in **flutter_secure_storage** (or equivalent); never in plain SharedPreferences for sensitive data.
- Validate and sanitize SDUI JSON on the client (e.g. allowlist known `type` and attribute keys) to avoid abuse if the endpoint is ever compromised.
- Strip or redact debug logs and `debugPrint` in release builds (or use a logging library that respects build type).

### 3.4 Android production setup

1. **Signing**
   - Create a keystore (e.g. `keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000`).
   - Create `android/key.properties` (do not commit):
     - `storePassword=...`, `keyPassword=...`, `keyAlias=...`, `storeFile=../path/to/upload-keystore.jks`
   - In `android/app/build.gradle.kts`, add signing config that reads `key.properties` and use it in `buildTypes { release { signingConfig = ... } }`.
   - Official docs: [Android app signing](https://docs.flutter.dev/deployment/android#signing-the-app).

2. **App name, package, version**
   - Set `applicationId` and version in `android/app/build.gradle.kts`.
   - Set human-readable app name in `android/app/src/main/AndroidManifest.xml` and in `res/values/strings.xml` if used.

3. **Permissions**
   - Keep only required permissions in `AndroidManifest.xml` (e.g. internet for API/SDUI). Remove any unused permissions.

4. **Build**
   - `flutter build appbundle` for Play Store. Test the AAB locally or with internal testing track before production.

### 3.5 iOS production setup

1. **Signing and capabilities**
   - In Xcode: select the Runner project → Signing & Capabilities. Choose your Team and provisioning profile.
   - Use **Automatically manage signing** or a production provisioning profile for release.

2. **Bundle ID and version**
   - Set Bundle Identifier and version in Xcode (or in `ios/Runner/Info.plist`). Match the version with `pubspec.yaml` if you use a script to sync.

3. **App Transport Security**
   - If you only call HTTPS APIs, you don’t need to allow arbitrary loads. Otherwise add an ATS exception in `Info.plist` only for the domains you need.

4. **Build and submit**
   - `flutter build ios` then open Xcode → Product → Archive. Upload to App Store Connect (or use fastlane / CI).
   - Ensure you have an App Store Connect app record and necessary agreements/compliance filled.

### 3.6 CI/CD (optional but recommended)

- **Android:** Use GitHub Actions / GitLab CI / etc. to run `flutter pub get`, `flutter analyze`, `flutter test`, then `flutter build appbundle`. Store keystore and `key.properties` as secrets; inject into the build.
- **iOS:** On a macOS runner, run `flutter build ios`, then use `xcodebuild archive` and `xcrun altool` (or fastlane) to upload to TestFlight/App Store. Store certificates and provisioning profiles as secrets.
- **Versioning:** Bump `version` in `pubspec.yaml` (and build number) from CI or a script so every store build has a unique version.

### 3.7 Checklist before going live

- [ ] API base URL and any keys come from environment or secure config, not hardcoded.
- [ ] Mock data fully replaced by real APIs (listings, company profile, and any SDUI payloads).
- [ ] Error handling and (optionally) retry for network requests; user-friendly error messages or fallback UI.
- [ ] Android release signed with your upload key; `key.properties` and keystore not in version control.
- [ ] iOS release signed with production provisioning profile; certificates and profiles managed securely.
- [ ] App name, icons, and splash (if any) updated for production.
- [ ] Privacy policy and store listing content ready (required for both stores).
- [ ] SDUI JSON schema documented and versioned; old app versions handled (e.g. ignore unknown keys, or maintain backward compatibility).

---

## 4. Summary

- **App:** Android and iOS only; starts at `ListingPage`, navigates to `CompanyPage` from a listing card.
- **Data:** Currently `MockData`; replace with API client and repositories, using the same models.
- **SDUI:** Registry in `sdui_bootstrap.dart`; load screens via `SDUIScreenLoader` (asset or API). Add new types in the registry and corresponding widgets as needed.
- **Production:** Use env/config for URLs and keys, sign Android and iOS builds, replace mocks with APIs, then build and submit via store consoles or CI/CD. Use this walkthrough as the single place to trace “how everything works” and “what to do for production.”
