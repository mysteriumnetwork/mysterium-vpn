import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/locations_refresh_icon_button.dart';

/// Wraps a locations scroll view with pull-to-refresh for the active tab's
/// type. Works on mobile (pull) and desktop (mouse/trackpad drag, enabled
/// app-wide via `dragDevices`). Uses [RefreshIndicator.adaptive] so the spinner
/// matches the platform — Cupertino on iOS/macOS, Material elsewhere.
class LocationsRefreshControl extends ConsumerWidget {
  const LocationsRefreshControl({required this.child, super.key});

  /// The scroll view to attach pull-to-refresh to.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(remoteConfigStorePOD).locationsPullToRefreshEnabled) {
      return child;
    }
    return RefreshIndicator.adaptive(
      displacement: 50,
      // RefreshIndicator only needs completion; the outcome drives the snackbar
      // inside refreshLocationsWithFeedback, so the returned bool is ignored.
      onRefresh: () async {
        await refreshLocationsWithFeedback(
          ref.read(locationsStorePOD),
          ref.read(locationsQueryStorePOD).ipType,
          analytics: ref.read(analyticsStorePOD),
          source: LocationsRefreshSource.pull,
        );
      },
      child: child,
    );
  }
}
