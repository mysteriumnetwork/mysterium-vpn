import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Where a locations refresh was triggered from (for analytics).
enum LocationsRefreshSource { button, pull }

/// Localized name of an IP type, matching the tab labels.
String locationTypeLabel(IPType type) => switch (type) {
  IPType.datacenter => LocaleKeys.ipTypeDataCenter.tr(),
  _ => LocaleKeys.ipTypeResidential.tr(),
};

/// Refreshes [type] locations, logs the trigger, and shows a snackbar naming
/// what was refreshed. Returns the refresh outcome so callers can react.
Future<bool> refreshLocationsWithFeedback(
  LocationsStore store,
  IPType type, {
  required AnalyticsStore analytics,
  required LocationsRefreshSource source,
}) async {
  analytics.logLocationsRefresh(type: type, source: source.name);
  final ok = await store.refresh(type);
  final label = locationTypeLabel(type);
  showSnackbar(
    ok
        ? LocaleKeys.locationsUpdated.tr(args: [label])
        : LocaleKeys.locationsUpdateFailed.tr(args: [label]),
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
    final locationsStore = ref.watch(locationsStorePOD);
    final refreshFuture = useState<Future<void>?>(null);
    final isRefreshing = useFuture(refreshFuture.value).connectionState == ConnectionState.waiting;
    final tooltip = useMemoized(
      () => LocaleKeys.refreshLocationsTooltip.tr(args: [locationTypeLabel(type)]),
      [type],
    );

    return RefreshIconButton(
      spinning: isRefreshing,
      tooltip: tooltip,
      color: Theme.of(context).palette.iconSecondary,
      onPressed: isRefreshing
          ? null
          : () => refreshFuture.value = refreshLocationsWithFeedback(
              locationsStore,
              type,
              analytics: ref.read(analyticsStorePOD),
              source: LocationsRefreshSource.button,
            ),
    );
  }
}
