# Residential IP Education — Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Teach users why their residential IP can change, via three surfaces — an on-demand info popover, a one-time full education modal (2nd residential connect, +2s), and a 30-day recurring reminder.

**Architecture:** Hybrid orchestration. A device-local `ResidentialEducationStore` (Hive) owns persisted state + a pure `decide()`. A home-shell hook (`useResidentialEducationTrigger`) owns the connection reaction, 2s timer, guards, and presentation. New design-lib widgets `ResidentialEducationModal` and `InfoPopover` render the surfaces; `MinimalAlert` gains a `titleAction` slot for the tappable info icon.

**Tech Stack:** Flutter, MobX, hooks_riverpod, flutter_hooks, Hive (local persistence), easy_localization, mysterium_vpn_design (local path override).

Spec: `docs/superpowers/specs/2026-06-08-residential-ip-education-design.md`

**Repos:** design lib at `../mysterium-vpn-design` (committed + released separately; app already has a local path override). App at repo root.

**Conventions:** `fvm` prefix for all flutter/dart commands. Codegen via `make generate` (build_runner). MobX stores use `_$Store` part + `flutter_mobx`. Commit frequently.

---

## Phase A — Design-lib components (`../mysterium-vpn-design`)

### Task A1: `InfoPopover` widget (shared "Why can my IP change?" surface)

**Files:**
- Create: `../mysterium-vpn-design/lib/widgets/info_popover.dart`
- Modify: `../mysterium-vpn-design/lib/widgets/widgets.dart` (export)
- Create: `../mysterium-vpn-design/test/widgets/info_popover_test.dart`
- Create: `../mysterium-vpn-design/widgetbook/lib/widgets/info_popover.dart`

**Design:** A compact card: leading home badge (`DecoratedIcon`, `UntitledUI.home_03`) + bold title (textSm/semibold) + two-paragraph body (textXs/regular) + a right-aligned **Got it** text button (brand color). Two `InfoPopoverVariant` values: `light` (bg `#fafafa`/`bgTooltip`, dark text) and `dark` (dark surface, light text). The widget is **content-only** (no anchoring) so it can be embedded in an overlay or a sheet; expose `onGotIt`.

- [ ] **Step 1: Failing test** — pump `InfoPopover(title:'T', body:'B', onGotIt: ...)`; expect title, body text present and a tappable "Got it" that invokes the callback. (`test/widgets/info_popover_test.dart`)
- [ ] **Step 2: Run** `cd ../mysterium-vpn-design && fvm flutter test test/widgets/info_popover_test.dart` → FAIL (no class).
- [ ] **Step 3: Implement** `InfoPopover` (StatelessWidget) with `title`, `body`, `onGotIt`, `variant`, optional `icon`. Use theme tokens (`palette`, `textStyles`, `spacing`, radius). Match Figma: padding `spacing.ms`, radius `kMd`, shadow `shadowLg`.
- [ ] **Step 4: Run** test → PASS. Run `fvm flutter analyze lib/widgets/info_popover.dart`.
- [ ] **Step 5:** Add export to `widgets.dart`; add widgetbook use case (light + dark knob); `cd widgetbook && make generate`.
- [ ] **Step 6: Commit** `feat: add InfoPopover widget`.

### Task A2: Anchored overlay helper `showInfoPopover`

**Files:**
- Modify: `../mysterium-vpn-design/lib/widgets/info_popover.dart` (add `showInfoPopover` + `InfoPopoverAnchor`)
- Modify: `../mysterium-vpn-design/test/widgets/info_popover_test.dart`

**Design:** `showInfoPopover({required BuildContext context, required GlobalKey anchorKey, required InfoPopover content})` opens an `OverlayEntry` with: a transparent full-screen barrier (tap → dismiss) and the popover positioned relative to the anchor's render box via its global rect, with a small triangle tail. Tail direction (above/below) chosen by available space. Returns a `Future` that completes on dismiss. `onGotIt` also dismisses. Provide an `InfoPopoverAnchor` wrapper (wraps child in a keyed box) for callers that don't already have a key.

- [ ] **Step 1: Failing test** — pump a button with an anchor key; call `showInfoPopover`; expect popover visible; tap barrier → dismissed (Future completes); re-open, tap Got it → dismissed.
- [ ] **Step 2: Run** test → FAIL.
- [ ] **Step 3: Implement** overlay + barrier + positioning (clamp within screen; flip tail near edges). Keep math in one private `_PopoverLayout`.
- [ ] **Step 4: Run** test → PASS; `fvm flutter analyze`.
- [ ] **Step 5: Commit** `feat: anchored showInfoPopover with outside-tap dismiss`.

### Task A3: `ResidentialEducationModal` content widget

**Files:**
- Create: `../mysterium-vpn-design/lib/widgets/residential_education_modal.dart`
- Modify: `../mysterium-vpn-design/lib/widgets/widgets.dart`
- Create: `../mysterium-vpn-design/test/widgets/residential_education_modal_test.dart`
- Create: `../mysterium-vpn-design/widgetbook/lib/widgets/residential_education_modal.dart`

**Design:** Light-surface content widget (the body of a sheet/dialog — the app presents it via `showBottomSheetDialog`). Structure (from Figma node 11571:476597):
- Brand badge (`DecoratedIcon` `home_03`, bg `#f9e8ff`, 48px, icon brand color).
- Title (textMd/semibold, center) + subtitle (textSm/regular tertiary, center).
- Three rows, each `DecoratedIcon` (bg `bgInfoIcon`/`#f5f5f5`, 32px) + title (textXs/semibold) + body (textXs/regular tertiary): `home_03`, `cloud_off`, `refresh_cw_02`.
- Primary **Got it** button (`Button` design-lib widget), `onGotIt`.
- All strings passed in as params (localization stays in the app). Icons fixed in the widget.

- [ ] **Step 1: Failing test** — pump with title/subtitle/3×(title,body)/gotItLabel; expect all texts + 3 `DecoratedIcon`s + Got it invokes callback.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** widget per Figma tokens.
- [ ] **Step 4: Run** → PASS; analyze.
- [ ] **Step 5:** export + widgetbook use case; `make generate`.
- [ ] **Step 6: Commit** `feat: add ResidentialEducationModal content widget`.

### Task A4: `MinimalAlert.titleAction` slot

**Files:**
- Modify: `../mysterium-vpn-design/lib/widgets/minimal_alert.dart`
- Modify: `../mysterium-vpn-design/test/widgets/minimal_alert_test.dart`

**Design:** Add optional `Widget? titleAction`. When `title != null` and `titleAction != null`, render `titleAction` beside the title **instead of** the built-in tooltip icon (assert not both set). This lets the residential card supply an `InfoPopover` trigger (tappable icon) rather than the Flutter-`Tooltip`-based `TooltipIcon`.

- [ ] **Step 1: Failing test** — `MinimalAlert(title:'T', message:'M', titleAction: Icon(...))`; expect the action widget rendered and no `TooltipIcon`.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** the slot (in the titled `Row`, prefer `titleAction` over `effectiveTooltip`).
- [ ] **Step 4: Run** full `minimal_alert_test.dart` → PASS; analyze.
- [ ] **Step 5: Commit** `feat: add titleAction slot to MinimalAlert`.

### Task A5: Release design lib + bump app ref

**Files:** Modify: `pubspec.yaml` (app), `pubspec.lock` (app).

- [ ] Commit all design-lib changes; create a new tag/ref (coordinate with maintainer — e.g. `0.0.18`).
- [ ] In the app `pubspec.yaml`, bump `mysterium_vpn_design` git `ref` to the new tag. Keep the existing local path `dependency_overrides` for now (dev). `fvm flutter pub get`.
- [ ] **Note:** the path override must be removed before the app PR merges (see spec). Flag in the PR description.

> If subagents run Phase A in a worktree, A5 is done once at the end of Phase A.

---

## Phase B — App persistence & store

### Task B1: Device-local Hive box for education state

**Files:**
- Modify: `lib/services/data/local/local_db_service.dart` (register + open a `residential_education` box)
- Create (if needed): a tiny typed model or use primitive keys in a dynamic box.

**Design:** Simplest robust option — a dynamic `Box` named `residential_education` (no adapter/typeId churn; existing typeIds 3–7 untouched), with string keys: `modalShown` (bool), `lastReminderShownAt` (int millisSinceEpoch), `connectCount` (int). Open it inside **`LocalDBService.initialize()`** (the real method name — NOT `init()`) alongside `user_data`:
```dart
await openBoxRecoverable<Box>(
  // ...recoverable args matching the user_data call...
  open: () => Hive.openBox('residential_education'),
);
```
Expose getters/setters on `LocalDBService`: `getEducationModalShown()/setEducationModalShown(bool)`, `getEducationReminderAt()` (returns `DateTime?` from stored millis) `/setEducationReminderAt(DateTime)`, `getResidentialConnectCount()/setResidentialConnectCount(int)`.

- [ ] **Step 1: Failing test** — `test/services/.../local_db_service` (or store test in B3) drives these getters/setters; round-trip persists. (If LocalDBService is hard to unit-test directly, cover persistence through the store in B3 with an in-memory Hive temp dir.)
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** box open + accessors.
- [ ] **Step 4: Run** → PASS; analyze.
- [ ] **Step 5: Commit** `feat: device-local residential education storage`.

### Task B2: `ResidentialEducationStore` (state + pure decide)

**Files:**
- Create: `lib/stores/residential_education_store.dart`
- Modify: `lib/stores/stores.dart` (export, if barrel)
- Modify: `lib/providers/state_providers.dart` (add `residentialEducationStorePOD`)
- Run: `make generate` (mobx codegen for `_$ResidentialEducationStore`)

**Design:**
```dart
enum EducationAction { none, showModal, showReminder }

abstract class _ResidentialEducationStore with Store {
  _ResidentialEducationStore(this._db) {
    educationModalShown = _db.getEducationModalShown();
    lastReminderShownAt = _db.getEducationReminderAt();
    residentialConnectCount = _db.getResidentialConnectCount();
  }
  final LocalDBService _db;

  @observable bool educationModalShown = false;
  @observable DateTime? lastReminderShownAt;
  @observable int residentialConnectCount = 0;

  /// Non-persisted single-instance guard (global, lives on the store).
  @observable bool uiInFlight = false;

  static const reminderInterval = Duration(days: 30);

  @action
  void recordResidentialConnect() {
    residentialConnectCount += 1;
    _db.setResidentialConnectCount(residentialConnectCount);
  }

  EducationAction decide(DateTime now) {
    if (!educationModalShown && residentialConnectCount >= 2) {
      return EducationAction.showModal;
    }
    if (educationModalShown &&
        (lastReminderShownAt == null ||
         now.difference(lastReminderShownAt!) >= reminderInterval)) {
      return EducationAction.showReminder;
    }
    return EducationAction.none;
  }

  @action
  void markModalShown(DateTime now) {
    educationModalShown = true;
    lastReminderShownAt = now; // seed reminder clock
    _db..setEducationModalShown(true)..setEducationReminderAt(now);
  }

  @action
  void markReminderShown(DateTime now) {
    lastReminderShownAt = now;
    _db.setEducationReminderAt(now);
  }
}
```

- [ ] **Step 1:** Write store (above) with `part 'residential_education_store.g.dart';` and the `ResidentialEducationStore = _... with _$...` typedef. Add POD provider.
- [ ] **Step 2:** `make generate` → `.g.dart` produced. `fvm flutter analyze`.
- [ ] **Step 3: Commit** `feat: ResidentialEducationStore`.

### Task B3: Store unit tests (truth table + persistence)

**Files:** Create `test/stores/residential_education_store_test.dart`.

**Design:** Use a temp Hive dir (`Hive.init(tempDir)`); construct store with a real `LocalDBService` (or a fake `LocalDBService` exposing the same accessors). Truth table for `decide(now)`:

| modalShown | count | lastReminder | expected |
|---|---|---|---|
| false | 1 | null | none |
| false | 2 | null | showModal |
| true | 3 | now-1s (post-modal) | none |
| true | 4 | now-29d | none |
| true | 4 | now-31d | showReminder |
| true | 4 | null | showReminder |

Plus: `recordResidentialConnect` increments + persists (reopen store → count survived); `markModalShown(now)` sets flag AND seeds `lastReminderShownAt`.

- [ ] **Step 1: Write tests** (all rows + persistence + seeding).
- [ ] **Step 2: Run** `fvm flutter test test/stores/residential_education_store_test.dart` → expect PASS (logic from B2).
- [ ] **Step 3: Commit** `test: residential education store decision + persistence`.

---

## Phase C — Connection signal (`VpnStore`)

### Task C1: `userConnectEpoch` observable

**Files:**
- Modify: `lib/stores/vpn_store.dart` (add `@observable int userConnectEpoch = 0;`, bump in `_logConnectionSuccess` when `!refreshIP`)
- Modify: `test/stores/vpn_store_test.dart` (or create) — bump only on non-refresh success.
- Run: `make generate`.

- [ ] **Step 1: Failing test** — simulate a successful non-refresh connect → `userConnectEpoch` increments by 1; a refresh success → no increment.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** the observable + increment line in `_logConnectionSuccess(refreshIP)` guarded by `!refreshIP`. `make generate`.
- [ ] **Step 4: Run** → PASS; analyze.
- [ ] **Step 5: Commit** `feat: VpnStore.userConnectEpoch signal for user-initiated connects`.

---

## Phase D — Trigger, wiring, info-icon, copy, analytics

### Task D1: Locale keys + analytics events

**Files:**
- Modify: `resources/langs/en.json` (add education-modal keys; reuse existing tooltip keys)
- Modify: `lib/common/enums/analytics_event.dart`
- Run: `make generate` (locale_keys codegen)

**Keys to add (English only):** `residentialEducationTitle`, `residentialEducationSubtitle`, `residentialEducationBlock1Title/Body`, `Block2Title/Body`, `Block3Title/Body` (exact copy in spec §6). Reuse existing `gotIt` if present else add `residentialEducationGotIt`. Do NOT modify `ipTypeResidentialTooltip*` (reused as-is).

**Events:** `residentialEducationShown`, `residentialEducationDismissed`, `residentialReminderShown`, `residentialReminderDismissed`, `residentialInfoTooltipShown`, `residentialInfoTooltipDismissed`.

- [ ] **Step 1:** Add keys + events; `make generate`.
- [ ] **Step 2:** `fvm flutter analyze`; confirm `LocaleKeys.residentialEducationTitle` resolves.
- [ ] **Step 3: Commit** `feat: residential education copy + analytics events`.

### Task D2: Info-icon rework on residential disclaimer

**Files:**
- Modify: `lib/views/locations/components/locations_disclaimer.dart`
- Create: `test/views/locations/locations_disclaimer_test.dart` (widget test)

**Design:** For `residential()`, instead of passing `tooltipTitle/tooltipBody` (which renders the Flutter-Tooltip `TooltipIcon`), pass a `titleAction`: a tappable `UntitledUI.info_circle` (size 16, tertiary) wrapped in an `InfoPopoverAnchor`; on tap call `showInfoPopover(...)` with light variant, title `ipTypeResidentialTooltipTitle`, body `ipTypeResidentialTooltipBody`, and log `residentialInfoTooltipShown` (and `...Dismissed` on close). `dataCenter()` stays as-is (no tooltip). Because `LocationsDisclaimer` is a `HookConsumerWidget`, hold the anchor `GlobalKey` via `useMemoized`.

- [ ] **Step 1: Failing test** — tapping the info icon shows the popover with the residential title; tapping outside dismisses.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement**; remove the old `tooltipTitle/tooltipBody` path for residential.
- [ ] **Step 4: Run** test + `fvm flutter analyze lib/views/locations/` → PASS.
- [ ] **Step 5: Commit** `feat: tappable info popover on residential disclaimer`.

### Task D3: `useResidentialEducationTrigger` hook

**Files:**
- Create: `lib/common/hooks/use_residential_education_trigger.dart` (a `part` of `hooks.dart`)
- Modify: `lib/common/hooks/hooks.dart` (add `part`)
- Create: `test/common/hooks/use_residential_education_trigger_test.dart`

**Design:** A hook returning void, mounted in the home scaffolds. Internals:
- `ref.watch` vpnStore, residentialEducationStore, homeTabsStore, analyticsStore.
- A MobX `reaction` via the existing **`useReaction`** hook (NOT `useAutorun`) on `vpnStore.userConnectEpoch`.
- On change (inside the reaction `effect`, which is fire-and-forget): if `vpnStore.location?.ipType == IPType.residential`, (re)start a 2s `Timer` stored in `useRef` (cancel previous; cancel on dispose). Use `Timer` (not `Future.delayed`) so `fakeAsync` controls it in tests.
- After 2s, guards: `vpnStore.isConnected`, `location.ipType == residential`, tab guard, `!store.uiInFlight`. For modal: `selected ∈ {map, locations}`; for reminder: `selected == map`.
- `store.recordResidentialConnect()`; `final action = store.decide(now)`.
  - `showModal`: `store.uiInFlight = true`; `analyticsStore.logEvent(residentialEducationShown)`. Note `showBottomSheetDialog` returns **`FutureOr<T?>`**, so do NOT chain `.whenComplete`. Instead:
    ```dart
    store.uiInFlight = true;
    try {
      analyticsStore.logEvent(AnalyticsEvent.residentialEducationShown);
      store.markModalShown(now); // seed clock; mark shown (idempotent)
      await Future.value(showBottomSheetDialog<void>(context,
        builder: (_) => ResidentialEducationModal(/* localized */, onGotIt: () => Navigator.of(context).pop())));
      analyticsStore.logEvent(AnalyticsEvent.residentialEducationDismissed);
    } finally {
      store.uiInFlight = false; // clears even on exception
    }
    ```
  - `showReminder` (only if `selected == map`): same `try/finally` shape with `Future.value(showInfoPopover(...))`, dark variant, anchored to the connection-bar key (see D4); on success path `store.markReminderShown(now)` + `residentialReminderShown`/`Dismissed` events. If the anchor key has no `currentContext` (not mounted) → skip presentation entirely (do NOT set `uiInFlight`, do NOT `markReminderShown`); it retries next qualifying connect.
  - `none`: nothing.
- The reminder anchor `GlobalKey` comes from `homeStateProvider` (Task D4).

- [ ] **Step 1: Failing tests** (fake timer + fakeAsync): epoch bump on residential → after 2s modal shown when count hits 2; disconnect before 2s → not shown; ipType switched at 2s → not shown; tab switched to settings → not shown; second rapid epoch bump → single instance.
- [ ] **Step 2: Run** → FAIL.
- [ ] **Step 3: Implement** the hook. Use `fakeAsync`-friendly timer (inject clock/`DateTime.now` via a parameter defaulting to real, to keep tests deterministic).
- [ ] **Step 4: Run** → PASS; analyze.
- [ ] **Step 5: Commit** `feat: residential education trigger hook`.

### Task D4: Wire hook + connected-card anchor into home scaffolds

**Files:**
- Modify: `lib/views/home/home_state.dart` (add `connectedCardKey = GlobalKey()` to `_HomeState`)
- Modify: `lib/components/connection_status_bar.dart` (attach the key to the bar's root box)
- Modify: `lib/views/home/home_mobile_scaffold.dart`, `lib/views/home/home_desktop_scaffold.dart` (call `useResidentialEducationTrigger(...)`)

**Anchor decision:** There is **no discrete "connected residential card"** widget — `HomeConnectionView` (both platforms, incl. `desktop_right_panel.dart`) is `ConnectionStatusBar` + `Stack(HomeMap, HomeBanner)`. Anchor the reminder to **`ConnectionStatusBar`** (the "Connected" bar, present on both mobile and desktop), via the `connectedCardKey` on `homeStateProvider`. **Fallback (spec-allowed):** if anchored tail-tracking proves flaky, present the reminder at a **fixed placement** near the bottom of the connection area with no tail — keep this as the simpler escape hatch.

- [ ] **Step 1:** Add `final connectedCardKey = GlobalKey();` to `_HomeState` (`home_state.dart`); it's already exposed via `homeStateProvider`.
- [ ] **Step 2:** Wrap `ConnectionStatusBar`'s root with that key (`KeyedSubtree`/attach to the outermost box).
- [ ] **Step 3:** Mount `useResidentialEducationTrigger()` in both scaffolds (only one is mounted per platform at a time); pass `homeStateProvider`'s `connectedCardKey`.
- [ ] **Step 4:** `fvm flutter analyze lib/views/home/ lib/components/connection_status_bar.dart`.
- [ ] **Step 5: Manual smoke** (optional, see Phase E).
- [ ] **Step 6: Commit** `feat: wire residential education trigger + reminder anchor`.

---

## Phase E — Verification

### Task E1: Full analyze + targeted test suites

- [ ] `cd ../mysterium-vpn-design && fvm flutter test test/widgets/info_popover_test.dart test/widgets/residential_education_modal_test.dart test/widgets/minimal_alert_test.dart && fvm flutter analyze`
- [ ] App: `fvm flutter test test/stores/residential_education_store_test.dart test/common/hooks/use_residential_education_trigger_test.dart test/views/locations/locations_disclaimer_test.dart`
- [ ] App: `fvm flutter analyze lib/` (no new issues in touched dirs).

### Task E2: Manual acceptance pass (real app)

Use `/run` or `/verify` to confirm against acceptance criteria:
- [ ] 2nd residential connect → modal after 2s; disconnect <2s → no modal; modal once per device.
- [ ] Mobile = bottom sheet, desktop = centered modal; VPN stays connected; all dismiss paths work; state saved.
- [ ] Reminder only ≥30d after modal; after 2s connected; not if disconnected <2s; dismiss via Got it / outside; `lastReminderShownAt` updated.
- [ ] Info icon → popover; dismiss via Got it / outside tap.

### Task E3: Pre-merge cleanup
- [ ] Remove the `mysterium_vpn_design` path `dependency_overrides` from app `pubspec.yaml`; ensure git `ref` points at the released design-lib tag; `fvm flutter pub get`.
- [ ] Run `/code-review` for correctness; open PR (note the design-lib release dependency).

---

## Notes / risks
- **Anchoring** is the riskiest UI piece (A2/D4). If precise tail-tracking proves flaky across Map/desktop-panel, fall back to a fixed near-card placement (spec allows it as a documented compromise) — but try anchored first.
- **fakeAsync clock**: thread `DateTime Function() now` (or a clock) into the hook/store decisions so the 2s delay and 30-day gate are deterministic in tests.
- **Codegen**: B2/C1/D1 require `make generate`. Don't hand-edit `.g.dart`.
- **Two repos**: Phase A lands in the design lib (separate commits/PR + release); the app PR depends on that release (Task A5/E3).
