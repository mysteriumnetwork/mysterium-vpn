# Residential IP Education — Design Spec

Date: 2026-06-08
Status: Approved (pre-implementation)
Branch: `feat/residential-ip-education`

## Problem

Most users don't understand how residential IPs work. When the app reconnects
them to a different residential IP (because the previous household node went
offline), they perceive it as random, unstable, or broken. This drives
frustration, support tickets, and negative reviews.

## Goal

Introduce educational UI that explains residential IP selection, fallback, and
refresh behaviour, so users understand *why* their IP can change. Three
surfaces, escalating in depth:

1. **Info-icon tooltip** — on demand, next to the Residential IPs description card.
2. **First-time full education modal** — shown once, the 2nd time the user
   connects to a residential IP.
3. **Recurring reminder** — a compact popover shown at most every 30 days after
   the full modal has been dismissed.

## Non-goals

- No changes to connection logic or fallback behaviour itself.
- No backend/profile schema changes (state is device-local).
- Other-locale translations are out of scope here (English only; handled later
  by the translation flow).

---

## Decisions (confirmed)

| Decision | Choice |
|---|---|
| State scope | **Per-device, local** (dedicated Hive box), not per-user `UserData`. |
| "Second time" counting | **Distinct user-initiated connects** that sustain connected-on-residential for 2s. Auto fallback/refresh reconnects do **not** count. |
| Reminder/tooltip anchoring | **Anchored popover with a directional tail** to the relevant card. |
| Tooltip implementation | **One shared custom popover** reused by the info-icon tap and the reminder (Flutter's `Tooltip` can't host a "Got it" button). |
| Orchestration | **Hybrid**: `ResidentialEducationStore` (state + pure decision) + a home-shell hook (reaction, 2s timer, guards, presentation). |

---

## Architecture

### Component map

```
mysterium-vpn-design (lib/widgets/)
├── residential_education_modal.dart   # full education content (modal/sheet body)
└── info_popover.dart                  # shared "Why can my IP change?" popover + anchor/tail

mysterium-vpn (lib/)
├── stores/residential_education_store.dart   # device-local state + pure decide()
├── services/data/local/...                   # Hive box for education state
├── common/hooks/use_residential_education_trigger.dart
├── common/enums/analytics_event.dart         # + new events
└── views/locations/components/locations_disclaimer.dart  # info icon → InfoPopover
```

### 1. Shared UI components (design lib)

**`ResidentialEducationModal`** (content widget; presented by the app via
`showBottomSheetDialog`):
- Brand home badge (circular, `bg-brand-secondary` tint, `home_03` glyph).
- Title `How Residential IPs work` (textLg/semibold, centered).
- Subtitle `Residential IPs are different from high-speed IPs. Here's what to expect.` (textSm/regular tertiary, centered).
- Three blocks, each = leading `DecoratedIcon` badge (bg `bg-info-icon`/#f5f5f5, 32px) + bold title (textXs/semibold) + body (textXs/regular tertiary). Confirmed `UntitledUI` glyphs:
  1. `UntitledUI.home_03` — **Real household devices** — "Residential IPs come from real household devices, making your traffic look like regular internet usage."
  2. `UntitledUI.cloud_off` — **Availability can change** — "Because these IPs are provided by real devices, some nodes may go offline unexpectedly."
  3. `UntitledUI.refresh_cw_02` — **Automatic reconnection** — "If your current IP becomes unavailable, the app reconnects you to the nearest available residential IP."
- The modal surface is **light** (bg-modals #fdfdfd, dark text #252b37, brand badge tint #f9e8ff) per Figma — even though the app shell is dark. Colors come from design tokens.
- Primary button **Got it** (full-width on mobile; auto-width centered on desktop).
- Presentation: `showBottomSheetDialog` → bottom sheet on mobile (drag handle, no ✕, dismiss via Got it / outside tap / slide down), centered modal on desktop (✕ shown, dismiss via Got it / outside click / ✕). Background dims and the VPN stays connected (both inherent to the wrapper).

**`InfoPopover`** (shared compact popover):
- Card: home badge + title (textSm/semibold) + body (textXs/regular) + **Got it** link button (brand color, right-aligned). Two-paragraph body.
- Anchoring: `CompositedTransformTarget` on the anchor + `OverlayPortal`/`CompositedTransformFollower` for the floating card, with a small directional tail. A transparent full-screen barrier captures outside taps to dismiss.
- `variant` param: light (over panel/list — `bg-tooltip #fafafa`, dark text) and dark (over the map — dark surface, light text).
- Dismiss: outside tap (barrier) or **Got it**. Returns/notifies on dismiss.

### 2. State & persistence — `ResidentialEducationStore`

Device-local Hive box (e.g. `residential_education`), independent of the
per-user `UserData`, so it is **not** reset by: app restart, screen change,
disconnect/reconnect, Map↔Locations switch, or account switch on the device.

Persisted fields:
- `bool educationModalShown` (default `false`)
- `DateTime? lastReminderShownAt` (default `null`)
- `int residentialConnectCount` (default `0`)

Side-effecting recorder and a **pure** decision are split (so the truth-table
tests have independent inputs and the recorder gets its own Hive round-trip
test). Both are called only after a connect has **sustained**
connected-on-residential for 2s:

```dart
enum EducationAction { none, showModal, showReminder }

/// Side effect: increments + persists the connect counter. Call once per
/// qualifying (sustained-2s, user-initiated) residential connect.
void recordResidentialConnect();

/// Pure read of current persisted state. No mutation.
EducationAction decide(DateTime now) {
  if (!educationModalShown && residentialConnectCount >= 2) {
    return EducationAction.showModal;
  }
  if (educationModalShown &&
      (lastReminderShownAt == null ||
       now.difference(lastReminderShownAt!) >= const Duration(days: 30))) {
    return EducationAction.showReminder;
  }
  return EducationAction.none;
}

/// educationModalShown = true AND seed lastReminderShownAt = now.
/// Seeding the reminder clock here treats the modal as the first
/// "education exposure", so the next reminder is gated 30 days out and a
/// reminder cannot fire on the connect immediately following the modal.
void markModalShown(DateTime now);

/// lastReminderShownAt = now; persist.
void markReminderShown(DateTime now);
```

Counting rules (explicit):
- A residential connect contributes to `residentialConnectCount` only once it
  has stayed connected-on-residential for the full 2s window. Sub-2s connects
  do not count and never trigger UI.
- The modal fires on the **first qualifying connect where
  `residentialConnectCount >= 2 && !educationModalShown`**. Pre-existing
  connects (before this feature shipped) are **not** retroactively counted, so
  for current users the modal effectively appears on their 2nd residential
  connect after the update.
- `markModalShown(now)` seeds `lastReminderShownAt = now`; the reminder is then
  gated to at most once per 30 days from the last education/reminder exposure.

### 3. Trigger orchestration — `useResidentialEducationTrigger()`

Mounted in `home_mobile_scaffold` and `home_desktop_scaffold`.

VpnStore addition: `@observable int userConnectEpoch`, incremented inside
`_logConnectionSuccess` only when `refreshIP == false`. This is the
"user-initiated connect reached connected" signal and excludes
fallback/refresh reconnections.

Hook flow:
1. MobX reaction on `userConnectEpoch`.
2. On change, if `vpnStore.location?.ipType == IPType.residential`, start a **2s
   timer** (cancel any previous timer first).
3. After 2s, re-check **guards**:
   - still `vpnStore.isConnected`
   - still residential (`location.ipType == residential`)
   - **tab guard** via `homeTabsStorePOD.selected` (MobX, not a router): the
     concrete check is `selected == HomeTab.map || selected == HomeTab.locations`
     for the **modal**, and `selected == HomeTab.map` for the **reminder** (the
     connected card it anchors to lives on the map/connection view; on desktop
     `HomeTab.locations` is `mobileOnly`, so desktop is always `map` + side
     panel). Settings/Products tabs → abort.
   - `store.uiInFlight == false` (single-instance guard — see below).
4. If all pass → `store.recordResidentialConnect()`, then
   `action = store.decide(DateTime.now())`:
   - `showModal` → set `uiInFlight`, present `ResidentialEducationModal` via
     `showBottomSheetDialog`; call `store.markModalShown(now)`; log analytics.
   - `showReminder` (only valid on `HomeTab.map`) → set `uiInFlight`, present
     `InfoPopover` (dark variant) anchored to the connected card;
     `store.markReminderShown(now)`; log analytics.
   - `none` → do nothing (counter already incremented).
5. **Single-instance guard**: a non-persisted `bool uiInFlight` lives on the
   **store** (not hook-local) so it is global regardless of which scaffold is
   mounted. Set when a surface opens; **cleared in `whenComplete`/`finally` of
   the presentation Future** (`showBottomSheetDialog` Future, or the
   `InfoPopover` dismiss callback) so an early dismissal, outside-tap, or
   exception cannot wedge the guard `true` and permanently suppress all future
   education UI device-wide. The `none` branch never sets it.

### 4. Entry points & wiring

- **Info icon**: the residential card's info icon is currently rendered
  *inside* the design-lib `MinimalAlert` from the `tooltipTitle`/`tooltipBody`
  params (it builds a `TooltipIcon.titled` internally — there is **no**
  `TooltipIcon` to replace in the app file). The real change: add an optional
  `titleAction`/`onInfoTap` slot to `MinimalAlert` (design lib) so a caller can
  supply a custom trailing widget next to the title. `LocationsDisclaimer.residential()`
  passes an `InfoPopover` trigger (light variant) into that slot instead of the
  `tooltipTitle`/`tooltipBody` path. The existing tooltip path stays for other
  `MinimalAlert` callers (e.g. products_browsing_view). Log
  `residentialInfoTooltipShown` on open.
- **Reminder** reuses `InfoPopover` (dark variant), shown only on `HomeTab.map`,
  anchored to the connected residential card (desktop: the connection card in
  the right panel over the map; mobile: the connection card on the map tab).
  The tail direction flips (above/below the anchor) based on available space so
  it stays on-screen near viewport edges. If, at trigger time, no anchor target
  is mounted, the reminder is skipped and **the 30-day clock is not advanced**
  (`markReminderShown` not called) — it will simply be re-attempted on the next
  qualifying residential connect (intended; no backoff). Log
  `residentialInfoTooltipDismissed` / `residentialReminderDismissed` when the
  respective popover closes (Got it or outside tap).
- **Trigger hook** mounted once in each platform scaffold; the responsive
  scaffold switch guarantees only one scaffold is mounted at a time, and the
  store-level `uiInFlight` guard covers any transient overlap.

### 5. Edge cases → mechanism

| Edge case | Handled by |
|---|---|
| Navigate away during 2s delay | Tab guard (`homeTabsStorePOD.selected`) re-checked at presentation; abort if not on the allowed tab(s). |
| Connection fails | Guard re-check (`isConnected == false`) → abort. |
| Switch Residential→High-speed before connected | `userConnectEpoch` only bumps on connected success; `ipType` re-checked at 2s → abort. |
| IP refresh/fallback within the 2s window | `userConnectEpoch` does not bump on refresh; if the refresh stays residential, guards still pass and the connect counts (intended). If a refresh switches away from residential, the `ipType` guard aborts. |
| App killed during 2s delay | Timer is in-memory only; nothing persisted → not shown next launch unless a new trigger occurs. |
| Rapid repeated reconnects | Prior timer cancelled on new epoch; store-level `uiInFlight` → at most one instance. |
| Once-per-device for modal | `educationModalShown` device-local flag. |
| State reset across restart/screen/disconnect | Device-local Hive persistence. |

### 6. Copy & localization (English)

New `en.json` keys (names indicative):
- `residentialEducationTitle` = "How Residential IPs work"
- `residentialEducationSubtitle` = "Residential IPs are different from high-speed IPs. Here's what to expect."
- `residentialEducationBlock1Title` = "Real household devices"
- `residentialEducationBlock1Body` = "Residential IPs come from real household devices, making your traffic look like regular internet usage."
- `residentialEducationBlock2Title` = "Availability can change"
- `residentialEducationBlock2Body` = "Because these IPs are provided by real devices, some nodes may go offline unexpectedly."
- `residentialEducationBlock3Title` = "Automatic reconnection"
- `residentialEducationBlock3Body` = "If your current IP becomes unavailable, the app reconnects you to the nearest available residential IP."
- `residentialEducationGotIt` = "Got it" (reuse an existing `gotIt` key if present)

**Shared popover copy — reuse existing keys, do NOT mutate translated strings.**
`ipTypeResidentialTooltipTitle` (already exactly "Why can my IP change?") and
`ipTypeResidentialTooltipBody` already exist and are translated across all
locale files. The info-icon popover and the reminder both reuse these keys
**as-is**. We do **not** rewrite the English body to the slightly shorter Figma
reminder wording — that would silently desync the existing translations. The
minor copy delta vs the Figma reminder is accepted; changing it would be an
explicit, separately-scoped change that also re-runs the translation flow.

Only the new education-modal keys above are added (English); their translations
are handled later by the translation flow.

### 7. Analytics

New `AnalyticsEvent`s (auto snake_cased), logged via `analyticsStore.logEvent`:
- `residentialEducationShown`
- `residentialEducationDismissed`
- `residentialReminderShown`
- `residentialReminderDismissed`
- `residentialInfoTooltipShown` / `residentialInfoTooltipDismissed` (symmetric, for funnels)

### 8. Testing

- **Unit** (`ResidentialEducationStore`): pure `decide(now)` truth table over
  `residentialConnectCount` ∈ {1,2,3}, `educationModalShown` ∈ {false,true},
  `lastReminderShownAt` ∈ {null, <30d, ≥30d} — including the row that
  `markModalShown(now)` seeds the reminder clock so a reminder cannot fire on
  the immediately-following connect. `recordResidentialConnect()` increment +
  Hive round-trip persistence as a separate test.
- **Widget**: modal renders title + subtitle + 3 blocks + Got it; **bottom sheet
  for `ScreenType < tablet`, centered modal for `ScreenType >= tablet`**
  (confirmed: `showBottomSheetDialog` uses `isDesktop = screenType >= ScreenType.tablet`); `InfoPopover` dismiss
  via Got it and via outside tap; light/dark variants.
- **Trigger** (fake timer/clock): shows after 2s; aborts on early disconnect,
  IP-switch, route-change; single instance under rapid reconnects.

---

## Acceptance criteria (from product spec)

First-time education
- 2nd successful residential connect → full modal after 2s connected.
- Disconnect before 2s → not shown.
- Already shown once → never shown again (device).

Modal behaviour
- Correct title, subtitle, three blocks + icons, Got it CTA.
- Mobile = bottom sheet; desktop = centered modal.
- Opens only after residential connection confirmed connected.
- Does not interrupt the active VPN connection.
- Dismiss via all supported options; education state saved after dismissal.

Recurring reminder
- Only if ≥30 days since last education/reminder exposure.
- After 2s connected; not shown if disconnected before 2s.
- Copy matches design; dismiss via Got it or outside tap.
- `lastReminderShownAt` updated after dismissal.
