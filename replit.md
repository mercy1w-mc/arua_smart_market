# Arua Smart Market

## Current foundation

This repository remains a normal Flutter project and is organized for incremental
feature work in VS Code or an Android development environment.

- `lib/app/` contains the app entry point, theme, and role-aware route map.
- `lib/shared/` contains the initial user and product models plus reusable brand
  and section widgets.
- `lib/features/auth/` contains the first sign-in experience and role selector.
- `lib/features/customer/` contains the responsive marketplace shell, product
  search/filtering, wishlist state, product details, and local cart state.
- `lib/features/farmer/` contains the responsive farmer dashboard, inventory
  summary, order preview, and validated add-product form.

The customer and farmer experiences currently use clearly labeled local demo
data. Authentication, persistence, image upload, payments, and backend
authorization are intentionally left as the next integration phase; no fake
successful payments or production credentials are included.

## Local Flutter commands

When a Flutter SDK is available:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

The Replit container used for this setup does not currently expose a Flutter
binary or an installable Flutter module, so runtime checks and a web Preview
workflow still need to be configured in an environment with Flutter support.