import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Where a locations refresh was triggered from (for analytics).
enum _RefreshSource { button, pull }

String _typeLabel(IPType type) => switch (type) {
  IPType.datacenter => S.current.ipTypeDataCenter,
  _ => S.current.ipTypeResidential,
};

/// Refreshes [type] locations, logs the trigger, and shows a snackbar naming
/// what was refreshed. Returns the refresh outcome.
Future<bool> _refresh(WidgetRef ref, IPType type, {required _RefreshSource source}) async {
  ref.read(analyticsStorePOD).logLocationsRefresh(type: type, source: source.name);
  final ok = await ref.read(locationsStorePOD).refresh(type);
  final label = _typeLabel(type);
  showSnackbar(
    ok ? S.current.locationsUpdated(label) : S.current.locationsUpdateFailed(label),
    type: ok ? SnackbarType.success : SnackbarType.error,
  );
  return ok;
}

/// Refreshes the [type] locations tab on demand, sitting beside the tab labels.
///
/// A tooltip names the type so it's clear which list refreshes; the icon spins
/// while in flight and a second tap is ignored until it settles.
class LocationsRefreshIconButton extends HookConsumerWidget {
  const LocationsRefreshIconButton({required this.type, super.key});

  final IPType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshFuture = useState<Future<bool>?>(null);
    final isRefreshing = useFuture(refreshFuture.value).connectionState == ConnectionState.waiting;

    return RefreshIconButton(
      spinning: isRefreshing,
      // Computed each build so it follows a runtime locale change.
      tooltip: S.current.refreshLocationsTooltip(_typeLabel(type)),
      color: Theme.of(context).palette.iconSecondary,
      onPressed: isRefreshing
          ? null
          : () => refreshFuture.value = _refresh(ref, type, source: _RefreshSource.button),
    );
  }
}

/// Wraps a locations scroll view with pull-to-refresh for the active tab's type.
///
/// Works on mobile (pull) and desktop (mouse/trackpad drag, enabled app-wide via
/// `dragDevices`). Uses [RefreshIndicator.adaptive] so the spinner matches the
/// platform — Cupertino on iOS/macOS, Material elsewhere.
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
      onRefresh: () async {
        await _refresh(ref, ref.read(locationsQueryStorePOD).ipType, source: _RefreshSource.pull);
      },
      child: child,
    );
  }
}
