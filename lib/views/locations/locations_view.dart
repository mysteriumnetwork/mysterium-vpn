import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/auto_select_ip_type_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/is_authenticated_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/retry_widget.dart';
import 'package:mysterium_vpn/components/user_intent_picker.dart';
import 'package:mysterium_vpn/components/user_intent_tooltip.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item_empty.dart';
import 'package:mysterium_vpn/views/locations/components/location_type_switcher.dart';
import 'package:mysterium_vpn/views/locations/components/locations_container.dart';
import 'package:mysterium_vpn/views/locations/components/locations_disclaimer.dart';
import 'package:mysterium_vpn/views/locations/components/locations_horizontal_list.dart';
import 'package:mysterium_vpn/views/locations/components/locations_sliver_list.dart';
import 'package:mysterium_vpn/views/locations/components/locations_sliver_loading.dart';
import 'package:mysterium_vpn/views/locations/components/recent_locations_loading.dart';
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

        return _Body(
          future: future,
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
    required this.recentLocations,
    required this.locationType,
    required this.locations,
    required this.topLocations,
    required this.onRecentLocationTapped,
    required this.onLocationTypeChanged,
    required this.onLocationTapped,
  });

  final ObservableFuture<VPNLocations> future;
  final List<VPNLocation> recentLocations;
  final IPType locationType;
  final List<VPNLocation> locations;
  final List<VPNLocation> topLocations;
  final void Function(VPNLocation) onRecentLocationTapped;
  final void Function(IPType) onLocationTypeChanged;
  final void Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final recentLocationsStore = ref.watch(recentLocationsStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final userIntentsStore = ref.watch(userIntentsStorePOD);
    final isAuthenticated = useIsAuthenticated();
    final recentsFutureStatus = useComputedValue(() => recentLocationsStore.future.status);
    final showUserIntents = useComputedValue(
      () =>
          remoteConfigStore.showUserIntents &&
          (userIntentsStore.intents.isNotEmpty ||
              userIntentsStore.intentsFuture.status == FutureStatus.pending),
    );

    if (future.value != null) {
      return MultiSliver(
        children: [
          if (showUserIntents) const _UserIntent(),
          if (showUserIntents) const SizedBox(height: 24),
          if (isAuthenticated && recentsFutureStatus == FutureStatus.pending) ...[
            const RecentLocationsLoading(),
            const SizedBox(height: 24),
          ] else if (recentLocations.isNotEmpty) ...[
            _RecentLocations(
              recentLocations: recentLocations,
              onLocationTapped: onRecentLocationTapped,
            ),
            const SizedBox(height: 24),
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
        children: const [
          RecentLocationsLoading(),
          SizedBox(height: 24),
          LocationsSliverLoading(),
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

    return MultiSliver(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Flexible(
              child: EasyText(
                LocaleKeys.userIntentLabel.tr(),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const UserIntentTooltip(),
          ],
        ),
        const SizedBox(height: 16),
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
  });

  final List<VPNLocation> recentLocations;
  final void Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: LocationsHorizontalList(
          title: LocaleKeys.recentLocations.tr(),
          items: recentLocations,
          onItemPressed: onLocationTapped,
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

    final typeSwitcherKey = ref.watch(homeStateProvider.select((it) => it.typeSwitcherKey));
    final locationsKey = ref.watch(homeStateProvider.select((it) => it.locationsKey));
    final searchKeyword = useComputedValue(() => locationsQueryStore.searchTrimmed);
    final isEmpty = useComputedValue(() => locationsStore.isEmpty);

    useAutoSelectIPType();

    return MultiSliver(
      children: [
        SliverPinnedHeader(
          child: Observer(
            builder: (context) => LocationTypeSwitcher(
              key: typeSwitcherKey,
              value: locationType,
              options: locationsStore.locationTypes,
              onChanged: onLocationTypeChanged,
            ),
          ),
        ),
        SliverClip(
          child: SliverStack(
            children: [
              SliverPositioned.fill(
                child: LocationsContainer(
                  key: locationsKey,
                  locationType: locationType,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                sliver: MultiSliver(
                  children: [
                    switch (locationType) {
                      IPType.datacenter => LocationsDisclaimer.dataCenter(),
                      _ => LocationsDisclaimer.residential(),
                    },
                    if (topLocations.isNotEmpty)
                      LocationsSliverList(
                        items: topLocations,
                        onItemPressed: onLocationTapped,
                      ),
                    if (topLocations.isNotEmpty && locations.isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Divider(thickness: 0.5, color: Palette.lightBlue),
                      ),
                    LocationsSliverList(
                      items: locations,
                      onItemPressed: onLocationTapped,
                      scrollToSelected: true,
                    ),
                    if ((isEmpty ?? false) && searchKeyword.isNotEmpty)
                      _Empty(
                        text: LocaleKeys.noLocationsKeyword.tr(
                          namedArgs: {'keyword': searchKeyword},
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

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: EasyText(text, color: theme.colorScheme.error, fontWeight: FontWeight.w700),
    );
  }
}
