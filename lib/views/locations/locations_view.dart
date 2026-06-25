import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/is_authenticated_hook.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliverView extends HookConsumerWidget {
  const LocationsSliverView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final recentLocationsStore = ref.watch(recentLocationsStorePOD);
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);

    final handleToggleConnection = useHandleToggleConnection();

    void handleSetLocationType(IPType value) {
      analyticsStore.logTabChange(value);
      locationsQueryStore.setIPType(value);
    }

    void handleLocationTapped(VPNLocation location) {
      handleToggleConnection(location: location);
    }

    void handleRecentLocationTapped(VPNLocation location) {
      handleToggleConnection(
        location: location,
        selectEvent: (connected) =>
            connected ? AnalyticsEvent.disconnectRecents : AnalyticsEvent.connectRecents,
      );
    }

    return Observer(
      builder: (context) {
        final locationType = locationsQueryStore.ipType;
        final future = locationsStore.locationsFuture;
        final locations = locationsStore.locations;
        final topLocations = locationsStore.topLocations;
        final recentLocations = recentLocationsStore.value;
        final hasNoServers = locationsStore.hasNoServers;

        return _Body(
          future: future,
          hasNoServers: hasNoServers,
          recentLocations: recentLocations,
          locationType: locationType,
          locations: locations,
          topLocations: topLocations,
          onRecentLocationTapped: handleRecentLocationTapped,
          onLocationTypeChanged: handleSetLocationType,
          onLocationTapped: handleLocationTapped,
        );
      },
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body({
    required this.future,
    required this.hasNoServers,
    required this.recentLocations,
    required this.locationType,
    required this.locations,
    required this.topLocations,
    required this.onRecentLocationTapped,
    required this.onLocationTypeChanged,
    required this.onLocationTapped,
  });

  final ObservableFuture<VPNLocations> future;
  final bool hasNoServers;
  final List<VPNLocation> recentLocations;
  final IPType locationType;
  final List<VPNLocation> locations;
  final List<VPNLocation> topLocations;
  final void Function(VPNLocation) onRecentLocationTapped;
  final void Function(IPType) onLocationTypeChanged;
  final void Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );
    final locationsStore = ref.watch(locationsStorePOD);
    final recentLocationsStore = ref.watch(recentLocationsStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final userIntentsStore = ref.watch(userIntentsStorePOD);
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final isAuthenticated = useIsAuthenticated();
    final recentsFutureStatus = useComputedValue(() => recentLocationsStore.future.status);
    final isSearching = useComputedValue(() => locationsQueryStore.searchTrimmed.isNotEmpty);
    final showUserIntents = useComputedValue(
      () =>
          remoteConfigStore.showUserIntents &&
          (userIntentsStore.intents.isNotEmpty ||
              userIntentsStore.intentsFuture.status == FutureStatus.pending),
    );
    final theme = Theme.of(context);
    final horizontalPadding = ScreenType.of(context) >= ScreenType.tablet ? theme.spacing.xl3 : 0.0;
    final sectionGap = theme.spacing.xl3;

    if (hasNoServers) {
      return MultiSliver(
        children: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: theme.spacing.xl3,
            ),
            sliver: const SliverToBoxAdapter(child: LocationsNoServersError()),
          ),
        ],
      );
    }
    if (future.value != null) {
      return MultiSliver(
        children: [
          if (!isSearching) ...[
            if (isAuthenticated && recentsFutureStatus == FutureStatus.pending) ...[
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                sliver: const RecentLocationsLoading(),
              ),
              SizedBox(height: sectionGap),
            ] else if (recentLocations.isNotEmpty) ...[
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                sliver: _RecentLocations(
                  recentLocations: recentLocations,
                  onLocationTapped: onRecentLocationTapped,
                  connectedLocation: connectedLocation,
                ),
              ),
              SizedBox(height: sectionGap),
            ],
            if (showUserIntents)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                sliver: const _UserIntent(),
              ),
            if (showUserIntents) SizedBox(height: theme.spacing.xl),
          ],
          _Locations(
            locations: locations,
            topLocations: topLocations,
            locationType: locationType,
            onLocationTypeChanged: onLocationTypeChanged,
            onLocationTapped: onLocationTapped,
          ),
        ],
      );
    }
    if (future.status == FutureStatus.pending) {
      return MultiSliver(
        children: [
          const RecentLocationsLoading(),
          SizedBox(height: theme.spacing.xl2),
          const LocationsSliverLoading(),
        ],
      );
    }

    return MultiSliver(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 260),
          child: RetryWdiget(
            asset: Asset.icons.globe,
            onRetry: locationsStore.refresh,
            error: future.error,
          ),
        ),
      ],
    );
  }
}

class _UserIntent extends HookConsumerWidget {
  const _UserIntent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final userIntentsStore = ref.watch(userIntentsStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final locationsEmpty = useComputedValue(() => locationsStore.isEmpty);
    final isLoading = useComputedValue(
      () =>
          vpnStore.connectionStatus == VpnConnectionStatus.connecting ||
          vpnStore.connectionStatus == VpnConnectionStatus.disconnecting,
    );

    final intents = useComputedValue(() => userIntentsStore.intentsFuture.value);
    final selected = useComputedValue(() => userIntentsStore.userIntent);
    final handleToggleConnection = useHandleToggleConnection();
    final theme = Theme.of(context);
    return MultiSliver(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing.s,
          children: [
            Flexible(
              child: Text(
                LocaleKeys.userIntentLabel.tr(),
                style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textTertiary),
              ),
            ),
            const UserIntentTooltip(),
          ],
        ),
        SizedBox(height: theme.spacing.md),
        UserIntentPicker(
          items: intents?.toList(),
          onChanged: isLoading || (locationsEmpty ?? true)
              ? null
              : (value) => handleToggleConnection(intent: value),
          value: selected,
        ),
      ],
    );
  }
}

class _RecentLocations extends StatelessWidget {
  const _RecentLocations({
    required this.recentLocations,
    required this.onLocationTapped,
    this.connectedLocation,
  });

  final List<VPNLocation> recentLocations;
  final void Function(VPNLocation) onLocationTapped;
  final VPNLocation? connectedLocation;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: LocationsHorizontalList(
      title: LocaleKeys.recentLocations.tr(),
      items: recentLocations,
      onItemPressed: onLocationTapped,
      connectedLocation: connectedLocation,
    ),
  );
}

class _Locations extends HookConsumerWidget {
  const _Locations({
    required this.locations,
    required this.topLocations,
    required this.locationType,
    required this.onLocationTypeChanged,
    required this.onLocationTapped,
  });

  final List<VPNLocation> locations;
  final List<VPNLocation> topLocations;
  final IPType locationType;
  final void Function(IPType) onLocationTypeChanged;
  final void Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final showRefreshButton = ref.watch(remoteConfigStorePOD).locationsRefreshButtonEnabled;
    final theme = Theme.of(context);

    final typeSwitcherKey = ref.watch(homeStateProvider.select((it) => it.typeSwitcherKey));
    final locationsKey = ref.watch(homeStateProvider.select((it) => it.locationsKey));
    final searchKeyword = useComputedValue(() => locationsQueryStore.searchTrimmed);
    final isEmpty = useComputedValue(() => locationsStore.isEmpty);
    final innerHorizontalPadding = ScreenType.of(context) >= ScreenType.tablet
        ? theme.spacing.xl3
        : 0.0;

    useAutoSelectIPType();

    // Used by LocationsSliverList to offset scroll-to-selected below the
    // pinned header so the selected item isn't hidden behind it.
    final stickyKey = useMemoized(GlobalKey.new);

    return MultiSliver(
      children: [
        SliverPinnedHeader(
          child: SizedBox(
            key: stickyKey,
            child: Observer(
              builder: (context) => LocationTypeSwitcher(
                key: typeSwitcherKey,
                value: locationType,
                options: locationsStore.locationTypes,
                onChanged: onLocationTypeChanged,
                activeTabTrailing: showRefreshButton
                    ? LocationsRefreshIconButton(type: locationType)
                    : null,
              ),
            ),
          ),
        ),
        SliverClip(
          child: SliverStack(
            children: [
              SliverPositioned.fill(
                child: LocationsContainer(key: locationsKey, locationType: locationType),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: innerHorizontalPadding,
                  vertical: theme.spacing.md,
                ),
                sliver: MultiSliver(
                  children: [
                    if (searchKeyword.isEmpty)
                      switch (locationType) {
                        IPType.datacenter => LocationsDisclaimer.dataCenter(),
                        _ => LocationsDisclaimer.residential(),
                      },
                    ScrollableLocationsSliverList(
                      items: locations,
                      onItemPressed: onLocationTapped,
                      stickyHeaderKey: stickyKey,
                    ),
                    if ((isEmpty ?? false) && searchKeyword.isNotEmpty)
                      SliverLayoutBuilder(
                        builder: (context, sliverConstraints) => SliverToBoxAdapter(
                          child: LocationsEmptySearchResult(
                            availableHeight: sliverConstraints.remainingPaintExtent,
                            onClear: () =>
                                locationsQueryStore.setSearch('', debounce: Duration.zero),
                          ),
                        ),
                      ),
                    if ((isEmpty ?? false) && searchKeyword.isEmpty) const LocationItemEmpty(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
