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
data while the backend integration is being staged. The client-side
`CatalogRepository` now connects farmer-created products to the customer
marketplace during the current session.

## Replit-only backend

The Replit environment now contains a private Node/PostgreSQL API in
`server/`. It is intentionally ignored by Git so the original GitHub
repository receives only the Flutter frontend. The API currently provides:

- Persistent users, roles, profiles, sessions, categories, products, carts,
  orders, wishlists, and notifications schema
- Password hashing with `bcryptjs`
- Session cookies and bearer-token support
- Customer/farmer role enforcement
- Public product search
- Farmer-owned product create, update, list, and archive endpoints
- Ownership checks that prevent customers or other farmers from managing data

The `Arua Smart Market API` workflow runs this backend on port 5000. Backend
credentials are read from Replit-managed environment variables; none are
stored in Flutter source or GitHub. Checkout, image storage, and the Flutter
API client remain the next integration phase. No fake successful payments are
implemented.

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