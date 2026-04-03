# MapLocationMarker Refactor Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the app-local `LocationMarker` widget and its separate tooltip `Marker` with the design system's `MapLocationMarker` in `location_markers_layer.dart`.

**Architecture:** `LocationMarkersLayer` currently builds two `Marker` objects per selected location — one pin and one tooltip overlay. After the refactor, each location gets a single `Marker` whose child is `MapLocationMarker`, which handles all three states (inactive, selected+label, connected) internally. The `Builder` wrapper inside the `Marker.child` provides a `BuildContext` for locale-aware name resolution at Flutter render time.

**Tech Stack:** Flutter, flutter_map (`MarkerLayer`/`Marker`), flutter_hooks (`useComputedValue`), MobX (reactive stores), `mysterium_vpn_design` package (`MapLocationMarker`).

**Spec:** `docs/superpowers/specs/2026-04-03-map-location-marker-design.md`

---

## File Map

| Action | Path | Reason |
|---|---|---|
| Modify | `lib/views/locations/location_markers_layer.dart` | Primary change — swap widget, update Marker sizes, remove tooltip block |
| Delete | `lib/components/location_marker.dart` | No callers after refactor |
| Delete | `lib/views/home/location_tooltip_card.dart` | No callers after refactor |

---

### Task 1: Verify no other callers of the files being deleted

Before deleting, confirm `LocationMarker` and `LocationTooltipCard` are used **only** in `location_markers_layer.dart`.

- [ ] **Step 1: Check callers of LocationMarker**

  Run:
  ```bash
  grep -r "LocationMarker" lib/ --include="*.dart" -l
  ```
  Expected output (exactly these two files):
  ```
  lib/components/location_marker.dart
  lib/views/locations/location_markers_layer.dart
  ```

- [ ] **Step 2: Check callers of LocationTooltipCard**

  Run:
  ```bash
  grep -r "LocationTooltipCard" lib/ --include="*.dart" -l
  ```
  Expected output (exactly these two files):
  ```
  lib/views/home/location_tooltip_card.dart
  lib/views/locations/location_markers_layer.dart
  ```

  If any extra files appear, stop and investigate before proceeding.

---

### Task 2: Rewrite `location_markers_layer.dart`

**File:** `lib/views/locations/location_markers_layer.dart`

- [ ] **Step 1: Replace the file contents**

  Replace the entire file with:

  ```dart
  import 'package:collection/collection.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_hooks/flutter_hooks.dart';
  import 'package:flutter_map/flutter_map.dart';
  import 'package:latlong2/latlong.dart';
  import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
  import 'package:mysterium_vpn/common/hooks/hooks.dart';
  import 'package:mysterium_vpn/models/models.dart';
  import 'package:mysterium_vpn/providers/state_providers.dart';
  import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

  class LocationMarkersLayer extends HookWidget {
    const LocationMarkersLayer({
      required this.locations,
      required this.selectedLocation,
      required this.connectedLocation,
      required this.onLocationPressed,
      this.onLocationDoubleTapped,
      super.key,
    });

    final List<VPNLocation> locations;
    final VPNLocation? selectedLocation;
    final VPNLocation? connectedLocation;
    final Function(VPNLocation location, LatLng point)? onLocationPressed;
    final Function(VPNLocation location, LatLng point)? onLocationDoubleTapped;

    @override
    Widget build(BuildContext context) {
      final markers = _useLocationMarkers(
        data: locations,
        selectedLocation: selectedLocation,
        connectedLocation: connectedLocation,
        onLocationPressed: onLocationPressed,
        onLocationDoubleTapped: onLocationDoubleTapped,
      );

      return MarkerLayer(markers: markers);
    }
  }

  List<Marker> _useLocationMarkers({
    required List<VPNLocation> data,
    required VPNLocation? selectedLocation,
    required VPNLocation? connectedLocation,
    required Function(VPNLocation, LatLng)? onLocationPressed,
    required Function(VPNLocation, LatLng)? onLocationDoubleTapped,
  }) {
    final remoteConfigStore = useProvider(remoteConfigStorePOD);
    final latLngStore = useProvider(latLngStorePOD);
    final onLocationPressedRef = useRef(onLocationPressed)..value = onLocationPressed;
    final onLocationDoubleTappedRef = useRef(onLocationDoubleTapped)..value = onLocationDoubleTapped;

    return useComputedValue<List<Marker>>(
      () {
        final cities = remoteConfigStore.showCitiesAndStates
            ? {
                ...data.where(
                  (it) =>
                      !it.isCountry &&
                      remoteConfigStore.countriesWithCitiesOnMap.contains(
                        it.countryCode.toUpperCase(),
                      ),
                ),
              }
            : const <VPNLocation>{};

        final countries = {
          ...data.where(
            (it) =>
                it.isCountry &&
                cities.none(
                  (city) => city.countryCode.toUpperCase() == it.countryCode.toUpperCase(),
                ),
          ),
        };

        final sorted = {
          ...cities,
          ...countries.whereNot(
            (it) =>
                it.countryCode == connectedLocation?.countryCode ||
                it.countryCode == selectedLocation?.countryCode,
          ),
          ?selectedLocation,
          if (connectedLocation != null && connectedLocation != selectedLocation) connectedLocation,
        };

        return sorted
            .map((it) {
              final point = it.isCountry
                  ? latLngStore.coordinatesForCountry(it.countryCode)
                  : latLngStore.coordinatesForCity(it);

              if (point == null) {
                return null;
              }

              final isConnected = connectedLocation?.id == it.id;
              final isSelected = selectedLocation?.id == it.id;
              final isActive = isConnected || isSelected;
              final hasLabel = isSelected && !isConnected;

              return Marker(
                point: point,
                width: hasLabel ? 200 : (isActive ? 60 : 20),
                height: hasLabel ? 80 : (isActive ? 60 : 20),
                alignment: hasLabel ? Alignment.bottomCenter : Alignment.center,
                child: Builder(
                  builder: (context) => MapLocationMarker(
                    isConnected: isConnected,
                    isSelected: isSelected,
                    label: hasLabel ? it.getName(context) : null,
                    onPressed: () => onLocationPressedRef.value?.call(it, point),
                    onDoubleTap: onLocationDoubleTappedRef.value != null
                        ? () => onLocationDoubleTappedRef.value?.call(it, point)
                        : null,
                  ),
                ),
              );
            })
            .nonNulls
            .toList();
      },
      [
        onLocationPressedRef,
        latLngStore,
        data,
        selectedLocation?.id,
        connectedLocation?.id,
        remoteConfigStore.showCitiesAndStates,
        remoteConfigStore.countriesWithCitiesOnMap,
      ],
    );
  }
  ```

- [ ] **Step 2: Run analyzer to catch any import or type errors**

  Run:
  ```bash
  flutter analyze lib/views/locations/location_markers_layer.dart
  ```
  Expected: No issues found.

  Common errors and fixes:
  - `MapLocationMarker` not found → confirm `mysterium_vpn_design` is in `pubspec.yaml` (it is, at `path: /Users/kristijanmitrikeski/.../mysterium-vpn-design/`)
  - `getName` not found → the `vpn_location.dart` extension import covers this
  - `ScreenType` conflict → if the analyzer reports ambiguous `ScreenType`, add `hide ScreenType` to the design system import: `import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;`

---

### Task 3: Delete unused files

- [ ] **Step 1: Delete `location_marker.dart`**

  ```bash
  rm lib/components/location_marker.dart
  ```

- [ ] **Step 2: Delete `location_tooltip_card.dart`**

  ```bash
  rm lib/views/home/location_tooltip_card.dart
  ```

- [ ] **Step 3: Run full analyzer to confirm no dangling references**

  Run:
  ```bash
  flutter analyze
  ```
  Expected: No issues found.

  If any file still imports the deleted files, remove those imports.

---

### Task 4: Run tests and commit

- [ ] **Step 1: Run the test suite**

  Run:
  ```bash
  flutter test
  ```
  Expected: All tests pass (the suite is store/unit tests only — no widget tests exist for these components).

- [ ] **Step 2: Commit**

  ```bash
  git add lib/views/locations/location_markers_layer.dart
  git rm lib/components/location_marker.dart
  git rm lib/views/home/location_tooltip_card.dart
  git commit -m "refactor: use MapLocationMarker from design system"
  ```
