# Contributing

Thanks for helping improve Jebena. The project is small and focused on offline
play, Amharic-first UI, and simple game modules.

## Before starting

- Check existing issues and the product specification.
- For a new game, describe its rules and player count before implementation.
  Do not assume a family or regional rules variant.
- Keep the app offline: do not add network permission, analytics, or advertising
  SDKs.
- Give every new dependency a one-line reason in `docs/DEPENDENCIES.md`.

## Code changes

- Format Dart code with `dart format`.
- Keep game-specific UI and logic inside that game folder.
- Put user-facing strings in the localization layer, Amharic first and English
  second.
- Add or update tests for behavior changes.

## Before sharing a change

Run these commands from the repository root:

```sh
flutter pub get
flutter analyze
flutter test
```

For Android build changes, also run:

```sh
flutter build apk --release --split-per-abi
```

Include the affected screen or device, steps to reproduce, and screenshots when
reporting a visual issue. Never include private player data in reports.
