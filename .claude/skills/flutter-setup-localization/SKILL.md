---
name: flutter-setup-localization
description: How localization works in THIS project — intl_utils + localizely_sdk with context-free `S.current` access and Localizely over-the-air updates. NOT vanilla gen_l10n (`generate: true` / `l10n.yaml` / `AppLocalizations.of(context)`). Use when adding/editing localized strings, wiring locales, or touching translation tooling.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Wed, 01 Jul 2026 00:00:00 GMT
---
# Localization in this project

> ⚠️ **This project does NOT use vanilla Flutter gen_l10n.** There is no `generate: true`,
> no `l10n.yaml`, and no `AppLocalizations.of(context)`. It uses **`intl_utils`** (build-time
> ARB → Dart codegen) + **`localizely_sdk`** (over-the-air translation updates), accessed
> **context-free via `S.current`**. The generic gen_l10n docs do not apply here.

## Stack at a glance

- **Source of truth:** [Localizely](https://localizely.com) project `c88d61d8-c2db-4b19-b798-7ab447a7b762`. ARB files in `lib/l10n/intl_*.arb` are pulled from / pushed to it.
- **Codegen:** `intl_utils` generates `lib/generated/l10n.dart` (the `S` class) + `lib/generated/intl/messages_*.dart`. Configured via the `flutter_intl:` block in `pubspec.yaml` (NOT `l10n.yaml`):
  ```yaml
  flutter_intl:
    enabled: true
    class_name: S
    main_locale: en
    arb_dir: lib/l10n
    output_dir: lib/generated
    localizely:
      project_id: c88d61d8-c2db-4b19-b798-7ab447a7b762
      ota_enabled: true
  ```
- **Access:** `S.current.someKey` (context-free — works in widgets, and anywhere `S` has been loaded). The project convention is `S.current`, NOT `S.of(context)`.
- **Delegates** (in `lib/app.dart`): `S.delegate` + `GlobalMaterialLocalizations.delegate` + `GlobalWidgetsLocalizations.delegate` + `GlobalCupertinoLocalizations.delegate`; `supportedLocales: S.delegate.supportedLocales`.
- **OTA:** `lib/entrypoints/app_initializer.dart` calls `Localizely.init(...)` then `Localizely.updateTranslations()` in deferred init, reloading `S` so updated strings apply without a rebuild.

## Editing / adding strings

1. Add the key to **`lib/l10n/intl_en.arb`** (source), with an empty `"@key": {}` metadata companion. For placeholders, declare them in the metadata (see below).
2. `make localizely-generate` — regenerates the `S` class (`intl_utils:generate`) + the `Tr.byKey` bridge, then formats. The bridge (`lib/l10n/tr_bridge_keys.g.dart`) is generated from `intl_en.arb` by the standalone `tool/tr_bridge_generator.dart` (fast; no build_runner). A build_runner builder (`tool/tr_bridge_builder.dart`, registered in `build.yaml`) regenerates it too via `make generate` / `dart run build_runner build` — both share `renderTrBridge`, and a drift-guard test (`test/l10n/tr_bridge_keys_drift_test.dart`) fails if the checked-in file goes stale.
3. Use it: `S.current.yourKey` (or `S.current.yourKey(arg)` for placeholders).
4. Translate + publish via Localizely (see Tooling). Other-locale ARBs come back via `make localizely-fetch`.

To translate strings into the other locales, use the **`translate-mysterium-locales`** skill (glossary, per-locale tone, placeholder/ICU rules). Note that skill still references the pre-migration `resources/` paths — the live files are now `lib/l10n/intl_*.arb`.

## Tooling (Makefile)

The management **API token** is resolved from the `LOCALIZELY_API_TOKEN` env var, else the gitignored `.env.localizely`. It is distinct from the runtime SDK token in `.env.dev`/`.env.prod`.

- `make localizely-fetch` — download the latest translations into `lib/l10n/*.arb`.
- `make localizely-upload` — push the source (`en`) ARB to Localizely (adds new keys, no overwrite). Per-language uploads use the REST API (`/v1/projects/{id}/files/upload?lang_code=…&overwrite=…`).
- `make localizely-generate` — regenerate `S` + the `Tr.byKey` bridge from local ARBs.
- `make localizely-sync` — fetch then generate.

## Conventions (follow these)

- **No translation in the domain layer.** Stores / models / enums / utils stay translation-free. Translation happens in the **view layer**. Stores emit typed errors (e.g. `AuthError`, `VpnError`); a view-layer mapper (`authErrorMessage`, `vpnErrorMessage`) resolves them to `S.current.*` and a reaction shows the snackbar.
- **Enum labels → typed mappers, not string keys.** Don't store translation-key strings on an enum. Map the enum to `S.current.*` in a `switch` in (or next to) the widget that renders it, so a renamed key fails at **compile time**. Example: the blocker/protocol/theme pickers switch on the enum inline.
- **Dynamic keys → `Tr.byKey`.** For keys only known at runtime (server country codes, ConfigCat plan/feature keys), use `Tr.byKey(key)` (logs on miss in debug) or `Tr.byKeyOrNull(key) ?? fallback` for probes / graceful fallback. Reserve this for genuinely dynamic keys — prefer typed `S.current.*` everywhere else.
- **Analytics logs stable identifiers, never localized text** (e.g. `mode.name`, an error-type name), so events don't vary by locale.
- **Locale resolution:** `arbLocaleFor(locale)` (`lib/l10n/arb_locale.dart`) is the single source for turning an app locale into the locale `S` should load — it keeps a country code only when a dedicated ARB exists (e.g. `pt-BR`), else falls back to the language code. Use it at every `S.load` site.
- **Locale persistence** (`SharedPreferenceService`) stores `locale.toLanguageTag()` so country variants (pt-BR vs pt-PT) round-trip; first launch falls back to the device locale.
- **New locale checklist:** add to `kSupportedLocales` (constants), iOS + macOS `CFBundleLocalizations`, upload/translate in Localizely. Android (no `resConfigs`) and Windows need no locale-list edit.

## ARB format (applies to intl_utils too)

Named placeholders — declare in metadata:
```json
"hello": "Hello {userName}",
"@hello": { "placeholders": { "userName": { "type": "String" } } }
```
→ generates `S.current.hello(userName)`.

ICU plurals (`other` mandatory; add `zero/few/many` only where the locale's CLDR requires):
```json
"nWombats": "{count, plural, =0{no wombats} =1{1 wombat} other{{count} wombats}}",
"@nWombats": { "placeholders": { "count": { "type": "num" } } }
```

Keys with no placeholders generate a getter (`S.current.key`) and are eligible for the `Tr.byKey` bridge; keys with placeholders generate a method (`S.current.key(arg)`) and must be called directly.
