# B2B Marketplace – Flutter App

Modern, mobile-first B2B marketplace UI with **Server-Driven UI (SDUI)** support, inspired by Myntra’s product grid and Airbnb’s card layout. **Android and iOS only** (web and desktop platforms removed).

## Features

- **Listing page** – Product grid with rounded cards, price range, MOQ, verified supplier badge, location, and CTAs (“Get Best Price”, “Contact Supplier”). Sticky filter bar (Price, MOQ, Location, Supplier Type) and sort dropdown. Skeleton loaders and empty state.
- **Company page** – Image-first company profile: hero banner, logo, tagline, trust chips (years, rating, certifications), tabs (Products | Gallery | About | Reviews), product grid, and horizontal gallery.
- **Design system** – Neutral palette, Inter typography, soft shadows, 16px rounded corners, consistent spacing.
- **SDUI** – Screens and components can be driven by JSON from the server. Registry in `lib/core/sdui/`; example payload in `assets/sdui/listing_screen.json`.

## Project structure

```
lib/
├── core/
│   ├── theme/           # AppColors, AppTypography, AppSpacing, AppDecorations, AppTheme
│   └── sdui/            # SDUINode, SDUIRegistry, SDUIRenderer, SDUIScreenLoader, bootstrap
├── data/
│   ├── models/          # ListingItem, CompanyProfile, CompanyProduct
│   └── mock_data.dart
├── features/
│   ├── listing/         # ListingPage, ListingCard, FilterBar, Skeleton, EmptyState
│   └── company/         # CompanyPage, CompanyHero, CompanyTabs, CompanyProductCard, CompanyGallery
└── main.dart
```

## Run (Android / iOS)

```bash
flutter pub get
flutter run
```

Use a connected Android device/emulator or iOS simulator (Xcode on macOS). See **WALKTHROUGH.md** for how the app works and how to move to production.

## Build for devices (APK / iOS)

**Android APK** (install on any Android device):

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`. Copy this file to your phone and install (enable “Install from unknown sources” if prompted).

**iOS** (requires macOS and Xcode):

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode, select your device or “Any iOS Device”, and use **Product → Archive** to create an IPA. Use **Window → Organizer** to distribute to connected devices (development/ad hoc) or to TestFlight/App Store.

## SDUI

1. Register components in `lib/core/sdui/sdui_bootstrap.dart`.
2. Screens are loaded via **SDUIScreenService**: server first (when configured), then bundled asset fallback.
3. **Production:** Set `SDUI_BASE_URL` so the app fetches screen JSON from your API. See **[docs/SDUI_API.md](docs/SDUI_API.md)** for the API contract.

```bash
flutter run --dart-define=SDUI_BASE_URL=https://your-api.com
flutter build apk --release --dart-define=SDUI_BASE_URL=https://your-api.com
```

Optional: `SDUI_API_KEY` for Bearer auth. If `SDUI_BASE_URL` is empty, only bundled assets are used.

Example JSON for the listing screen:

```json
{
  "type": "ListingScreen",
  "attributes": {
    "skeleton": false,
    "empty": false
  }
}
```
