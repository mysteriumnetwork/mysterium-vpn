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
- Three blocks, each = leading `DecoratedIcon` badge + bold title (textSm/semibold) + body (textSm/regular tertiary):
  1. `home_03` — **Real household devices** — "Residential IPs come from real household devices, making your traffic look like regular internet usage."
  2. availability-off glyph (exact `UntitledUI` name resolved from Figma at implementation; visually an eye/availability-off icon) — **Availability can change** — "Because these IPs are provided by real devices, some nodes may go offline unexpectedly."
  3. `refresh_cw_*` — **Automatic reconnection** — "If your current IP becomes unavailable, the app reconnects you to the nearest available residential IP."
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

Pure decision (no `BuildContext`; unit-testable). Called only after a connect
has **sustained** connected-on-residential for 2s:

```dart
enum EducationAction { none, showModal, showReminder }

EducationAction decideOnResidentialConnect(DateTime now) {
  residentialConnectCount += 1;            // persist
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

void markModalShown();          // educationModalShown = true; persist
void markReminderShown(now);    // lastReminderShownAt = now; persist
```

Counting rule (explicit): a residential connect contributes to
`residentialConnectCount` only once it has stayed connected-on-residential for
the full 2s window. Sub-2s connects do not count and never trigger UI.

`reminderShownToday` semantics: reminder fires at most once per 30 days from the
last reminder/education exposure.

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
   - current route is the home shell (Map / Locations / connection visible) —
     not Settings/Products/auth/etc.
   - no education UI already open (single in-flight flag)
4. If all pass → `action = store.decideOnResidentialConnect(DateTime.now())`:
   - `showModal` → present `ResidentialEducationModal` via `showBottomSheetDialog`; on first present call `store.markModalShown()`; log analytics.
   - `showReminder` → present `InfoPopover` (dark variant) anchored to the connected card; `store.markReminderShown(now)`; log analytics.
   - `none` → do nothing.
5. Single in-flight flag cleared when the surface is dismissed.

### 4. Entry points & wiring

- **Info icon** on the Residential IPs description card
  (`locations_disclaimer.dart`): replace the current `TooltipIcon`
  (Flutter `Tooltip`) with a tap target that opens `InfoPopover` (light
  variant), anchored to the icon. Log `residentialInfoTooltipShown`.
- **Reminder** reuses `InfoPopover` (dark variant) anchored to the connected
  residential card on Map (desktop: over the map; mobile: compact popover near
  the connected card area).
- **Trigger hook** mounted once in each platform scaffold.

### 5. Edge cases → mechanism

| Edge case | Handled by |
|---|---|
| Navigate away during 2s delay | Route guard re-checked at presentation; abort if not on home shell. |
| Connection fails | Guard re-check (`isConnected == false`) → abort. |
| Switch Residential→High-speed before connected | Epoch only bumps on connected success; ipType re-checked at 2s → abort. |
| App killed during 2s delay | Timer is in-memory only; nothing persisted → not shown next launch unless a new trigger occurs. |
| Rapid repeated reconnects | Prior timer cancelled on new epoch; single in-flight flag → at most one instance. |
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
- Shared popover: `ipTypeResidentialTooltipTitle` = "Why can my IP change?",
  `ipTypeResidentialTooltipBody` = "Residential IPs come from real households, so availability may change.\n\nIf IP goes offline, the app reconnects you to the nearest available residential IP."

The info-icon tooltip and the reminder share the same "Why can my IP change?"
copy (standardize on this shorter Figma wording; updates the two task-1 tooltip
keys). English only; other locales handled by the translation flow.

### 7. Analytics

New `AnalyticsEvent`s (auto snake_cased), logged via `analyticsStore.logEvent`:
- `residentialEducationShown`
- `residentialEducationDismissed`
- `residentialReminderShown`
- `residentialReminderDismissed`
- `residentialInfoTooltipShown`

### 8. Testing

- **Unit** (`ResidentialEducationStore.decide`): truth table over
  `residentialConnectCount` ∈ {1,2,3}, `educationModalShown` ∈ {false,true},
  `lastReminderShownAt` ∈ {null, <30d, ≥30d}. Hive round-trip persistence.
- **Widget**: modal renders title + subtitle + 3 blocks + Got it; bottom sheet
  on mobile vs centered modal on desktop by `ScreenType`; `InfoPopover` dismiss
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
