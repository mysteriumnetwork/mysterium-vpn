# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Next-gen Mysterium VPN client — a single Flutter codebase targeting mobile (iOS/Android) and desktop (Windows/macOS/Linux). It connects through WireGuard and OpenVPN, gates features via ConfigCat, and ships translations over-the-air via Localizely.

## Commands

All Flutter/Dart commands **must** be prefixed with `fvm` (Flutter 3.44.7 is pinned in `.fvmrc`). Prefer the `Makefile` targets, which already include `fvm`:

- `make run-dev` — run the app in the `dev` flavor (runs `pub get` + codegen first)
- `make generate` — regenerate all codegen (`build_runner` for MobX `.g.dart`, Freezed `.freezed.dart`, JSON, Hive, asset gen) then `dart format --line-length 100`. **Always use this for codegen — do not call `build_runner` directly.**
- `make run-unit-tests` — full unit-test suite; runs once with `.env.dev` and once with `.env.prod` (the second pass only re-runs `env_test.dart`)
- `make clean` — `flutter clean`

Apple builds are hybrid Swift Package Manager + CocoaPods (`make init` enables SPM explicitly). Do not disable SPM or remove the workarounds documented in the Makefile header (PatrolImpl modulemap flag in the macOS Runner configs).

Crashlytics dSYMs are uploaded by CI only (`.github/scripts/upload-crashlytics-symbols.sh`, called from the iOS/macOS build workflows) — the generated Xcode build phase was removed because it pointed at `$PODS_ROOT` and silently uploaded nothing after the SPM migration. A build archived locally from Xcode therefore ships unsymbolized.

Single test / targeted runs (unit & widget tests need the dotenv defines):

```
fvm flutter test --dart-define-from-file=.env.dev --dart-define _DOTENV_FILE=.env.dev test/path/to/foo_test.dart
fvm flutter test --dart-define-from-file=.env.dev --dart-define _DOTENV_FILE=.env.dev --plain-name "test name"
fvm flutter analyze
```

Integration tests use Patrol (`integration_test/`):

- `make run-integration-tests` / `make debug-integration-tests` — device runs (`flags=...` passes extra args)
- `make build-ios-integration-test` / `make build-android-integration-test` → then `make run-ios-testlab` / `make run-android-testlab` for Firebase Test Lab

### Localization commands

Localization is **not** vanilla `gen_l10n`. `flutter_intl` is intentionally `enabled: false` in `pubspec.yaml`, so `pub get` no longer regenerates l10n. After editing ARB files:

- `make localizely-generate` — regenerate the `S` class (intl_utils) + the `Tr.byKey` bridge, then format
- `make localizely-fetch` — pull latest OTA translations into `lib/l10n/*.arb`
- `make localizely-upload` — push source (en) ARB to Localizely (adds keys, doesn't overwrite)
- `make localizely-sync` — fetch + generate

Localizely management commands need a **management** API token via `LOCALIZELY_API_TOKEN` env var or `.env.localizely` (both gitignored) — distinct from the runtime SDK token in `.env.dev`/`.env.prod`. See the `flutter-setup-localization` skill for details.

## Flavors & environment

Two build flavors, `dev` and `production`, selected at compile time via `--dart-define ENV_APP=<flavor>` and fed config from `--dart-define-from-file .env.<flavor>`. `Env` (`lib/env.dart`) reads all runtime config (base URLs, Sentry DSN, ConfigCat SDK keys, Notifier base URL + public API key, Apple client id, etc.). `Env.flavor` drives Firebase options, desktop window sizing, and test-vs-prod bundle ids.

## Architecture

**State: MobX stores + Riverpod providers.** Business logic lives in MobX `Store` classes under `lib/stores/` (each `foo_store.dart` has a generated `foo_store.g.dart` — regenerate with `make generate`). Stores are wired together and exposed through Riverpod providers (suffix `POD`):

- `lib/providers/service_providers.dart` — services (Dio/network, VPN engines, ConfigCat client, in-app purchase, etc.)
- `lib/providers/state_providers.dart` — stores, composed by `watch`-ing service and other store providers
- `lib/providers/repository_providers.dart` — repositories

Stores stay translation-free: they emit typed errors/state, and the **view layer** translates and surfaces them (see `authError` → `showSnackbar` in `lib/app.dart`). `lib/app.dart` (`MyApp`) is the composition root — it reads providers, sets up MobX reactions (auth, locale) via `flutter_hooks`, and on logout explicitly disposes/invalidates the connection-related stores.

**Layers:** `services/` (external I/O: `api`, `auth`, `mqtt`, `location`, `subscription`, `wiregurad`, `news_center`, `data` for local storage) → `repositories/` → `stores/` (state) → `views/` & `pages/` & `components/` (UI). Shared helpers live in `lib/common/` (`enums`, `hooks`, `interceptors`, `router`, `extensions`, `utils`, `forms`, `observers`, `layout_builders`). Barrel files (`stores.dart`, `services.dart`, `components.dart`, `models.dart`) re-export their directories; prefer `package:mysterium_vpn/...` absolute imports (enforced by lint).

**Networking:** a single Dio instance (`vpnApiDioPOD`) wires a fixed interceptor chain — connection-error handling, bearer-token injection, `RefreshTokenInterceptor`, retry, dev/debug logging, then API-error mapping. The backend client is the external `vpn_api` git package.

**Startup:** `main.dart` → `Env.init()` → Sentry → `AppInitializer` (`lib/entrypoints/app_initializer.dart`). `AppInitializer` owns the Riverpod `ProviderContainer`, initializes local storage/prefs/secure-storage/Hive + preloads localizations before the first frame, then runs Firebase + OTA translations as **deferred** init past the first frame (the splash awaits `deferredInitFuturePOD`).

**Routing:** Beamer. Routes are enumerated in `lib/common/enums/routes.dart`; the delegate/parser live in `lib/common/router/`. Auth status changes trigger `routeDelegate.update()`.

**Feature flags:** ConfigCat via `lib/stores/remote_config/` (`RemoteConfigStore`, `ConfigCatStore`, plus `AbTestingStore` and a per-user store). When adding a flag, add its corresponding cases to `test/stores/remote_config_store_test.dart` (default / valid / wrong-type / out-of-range).

**Analytics:** abstracted behind `AnalyticsStore` with platform implementations (`analytics_store_firebase.dart` on mobile, `analytics_store_windows.dart` on desktop). A ref-less `analyticsStoreRef` is exposed for use in util functions.

**Localization runtime:** `S.current` (intl_utils) is context-free but **not observable**. `lib/app.dart` reacts to locale changes and OTA translation arrival by bumping a `localizationRevision` `ValueNotifier`, which remounts the page subtree (via `KeyedSubtree`) so `const` widgets re-read `S.current`. This `ValueListenableBuilder` is deliberately scoped *below* the Beamer `Router` to avoid "setState during build" crashes — do not move it above.

## Local design-system development

UI widgets come from the `mysterium_vpn_design` package, pinned to a git ref in `pubspec.yaml`. To develop against a local checkout, add a path `dependency_override` in `pubspec_overrides.yaml` pointing at the sibling `mysterium-vpn-design` repo. New design-system widgets need a test, dartdoc, and a Widgetbook use-case — not just the widget.

## Conventions

- **Formatting:** `dart format` with `--line-length 100` (also set as `formatter.page_width` in `analysis_options.yaml`). Generated files (`*.g.dart`, `*.freezed.dart`), `lib/gen/`, `lib/generated/`, and `packages/vpn_api/` are excluded from analysis.
- **Lints:** strict — `flutter_lints` plus a large custom rule set (`strict-casts`, `strict-raw-types`, `always_use_package_imports`, `always_declare_return_types`, etc.). Run `fvm flutter analyze` before finishing.
- **Comments:** terse. Default to none; if a comment is needed, keep it to one short line.
- **Tests** mirror `lib/` under `test/` (`test/stores`, `test/views`, `test/services`, …); `test/support/` holds fakes and helpers, `flutter_test_config.dart` is the shared harness config.
