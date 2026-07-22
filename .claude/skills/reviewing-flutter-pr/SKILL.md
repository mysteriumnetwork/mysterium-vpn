---
name: reviewing-flutter-pr
description: Use before opening a PR in the mysterium-vpn Flutter app — self-review the working diff for codegen freshness, vpn_api model migrations, MobX/Observer reactivity, localization rules, feature-flag test coverage, design-system dependency hygiene, and clean analyze/test runs.
---

# Reviewing a Flutter PR before creating it

## Overview

A pre-PR self-review pass for the `mysterium-vpn` Flutter app. Run it on the
working diff **before** creating the PR — it catches the mistakes that this
repo's toolchain makes easy to miss (stale generated code, uncommitted local
overrides, silent MobX reactivity bugs) and that a human reviewer can't see
from the diff alone.

Commands in this repo are always prefixed with `fvm`. Codegen is always
`make generate` (never `build_runner` directly). Do not commit anything unless
the user asks.

## When to use

- You've finished a feature/bugfix and are about to open a PR.
- You touched a MobX store, a mocked service interface, analytics signatures,
  ARB strings, or bumped a git dependency (especially `vpn_api`).
- The user says "review before we create a PR" / "ready for PR?".

## The checklist

Work top to bottom. Create a todo per section if the diff is large.

### 1. Scope the diff

```bash
git status
git diff            # working tree (this repo often reviews BEFORE commit)
git diff --stat
```

Read every changed hunk. Flag leftover debug logging, temporary
instrumentation tags (e.g. `[OFFLINE-AVAIL-BUG]`), commented-out code, dead
code, and stray `print`/`debugPrint`.

### 2. Codegen is fresh (the #1 miss)

Any change to a **MobX store** (`@observable/@computed/@action`), a **mocked
interface**, an **analytics method signature**, or an **ARB file** requires
regeneration:

```bash
make generate                       # mobx .g.dart + mockito .mocks.dart + tr bridge
git diff --stat '*.g.dart' '*.mocks.dart'
```

Then prove nothing stale survived — grep for any renamed/removed symbol across
BOTH `lib` and `test`:

```bash
grep -rn "OldTypeName\|oldMethodName" lib test    # expect: no matches
```

Generated files (`*.g.dart`, `*.mocks.dart`) are regenerated, never
hand-edited.

### 3. vpn_api / dependency bumps

When a git dependency ref changed in `pubspec.yaml` (verify `pubspec.lock`
`resolved-ref` updated too), generated model **type names can change** — e.g.
`NewscenterInboxListResponseMessagesInner` → `NewscenterInboxListResponseItem`,
a per-model category enum → a shared `NewscenterCategory`.

Migration order that avoids prefix collisions: rename the **longer / more
specific** symbol first (the `...CategoryEnum`), then the base type. Edit only
hand-written files; let `make generate` fix `*.g.dart`/`*.mocks.dart`. Then run
the grep from step 2 to confirm zero stale references anywhere.

### 4. MobX + Observer reactivity

An `Observer` only tracks observables **read synchronously during its build**.
Observables read inside a lazily-invoked builder — `SliverList.separated`'s
`itemBuilder`, `ListView.builder`, etc. — are NOT tracked by the enclosing
`Observer`, so mutations won't rebuild. Symptom: a value updates only after an
unrelated state change forces a rebuild (e.g. read-state only refreshing after
switching filters).

Fix: read the observable eagerly in the tracked build, or wrap the per-item
widget in its own `Observer`. If the diff adds a lazy list bound to store
state, confirm there's a test that mutates the store and asserts the row
updates in place.

### 5. Localization

- Domain layer (stores/models/enums/utils) stays translation-free; translate in
  the view layer via `S.current.*`.
- EN-only features use hardcoded strings + forced `Directionality(TextDirection.ltr)`;
  never format dates with a locale-dependent `DateFormat` (it throws
  `LocaleDataException` when the app locale ≠ en and its symbols aren't loaded).
- Added/edited real strings? They go in `lib/l10n/intl_en.arb`, then
  `make localizely-generate` (NOT plain `pub get` — `flutter_intl` is disabled
  on purpose).

### 6. Feature flags

New ConfigCat flag? Add `remote_config_store_test` cases: default, valid,
wrong-type, out-of-range. Confirm the flag's prod default matches intent.

### 7. Design-system dependency hygiene (release blocker)

The app consumes `mysterium_vpn_design` via a **local path override in
`pubspec_overrides.yaml`** — a dev-only file. Before PR:

```bash
git ls-files pubspec_overrides.yaml      # expect: empty (must NOT be committed)
git check-ignore pubspec_overrides.yaml  # ideally gitignored
```

If the feature relies on new DS widgets, those must be committed to the design
repo and `pubspec.yaml`'s `mysterium_vpn_design` git `ref` bumped to include
them — otherwise CI builds against a ref without the widgets and fails. New DS
widgets also need test + dartdoc + Widgetbook use-case.

### 8. Green gates

```bash
fvm flutter analyze                      # expect: No issues found!
fvm flutter test test/<feature paths>    # the suites you touched, all pass
```

State results plainly with the actual output. If a test was skipped or a step
not run, say so — don't imply coverage you didn't produce.

## Quick reference

| Trigger in the diff | Required action |
|---|---|
| MobX store / mock / analytics sig / ARB changed | `make generate` + stale-symbol grep |
| Git dep ref bumped | migrate renamed types (specific-first), regen, grep |
| Lazy list bound to store state | eager read or inner `Observer` + in-place-update test |
| New localized string | `intl_en.arb` + `make localizely-generate` |
| New ConfigCat flag | 4 `remote_config_store_test` cases |
| New DS widget | commit to design repo + bump `pubspec.yaml` ref |
| Any change | `fvm flutter analyze` clean + touched tests pass |

## Common mistakes

- Editing a `.g.dart`/`.mocks.dart` by hand instead of regenerating.
- Running `build_runner` directly or dropping the `fvm` prefix.
- Committing `pubspec_overrides.yaml` (leaks a local path into the repo).
- Trusting `flutter analyze` alone — it won't catch a MobX reactivity bug or an
  uncommitted DS ref; only running the app / a targeted test will.
- Committing when the user only asked for a review.
