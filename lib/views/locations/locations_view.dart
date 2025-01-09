import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/retry_widget.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_type_switcher.dart';
import 'package:mysterium_vpn/views/locations/components/locations_container.dart';
import 'package:mysterium_vpn/views/locations/components/locations_disclaimer.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';
import 'package:mysterium_vpn/views/locations/components/locations_sliver_list.dart';
import 'package:mysterium_vpn/views/locations/components/locations_sliver_loading.dart';
import 'package:mysterium_vpn/views/locations/components/recent_locations_list.dart';
import 'package:mysterium_vpn/views/locations/components/recent_locations_loading.dart';
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliverView extends HookConsumerWidget {
  const LocationsSliverView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final locationsStore = ref.watch(locationsStorePOD);
    final locationType = ref.watch(homeStateProvider.select((it) => it.ipType));

    final state = useComputedValue(() => locationsStore.vpnLocationsFuture);

    final locations = useComputedValue(
      () => switch (locationType) {
        IPType.residential => locationsStore.allLocations,
        IPType.datacenter => locationsStore.dcLocations,
      },
      [locationType],
    );

    final topLocations = useComputedValue(
      () => switch (locationType) {
        IPType.residential => locationsStore.topLocations,
        IPType.datacenter => const <VPNLocation>[],
      },
      [locationType],
    );

    final recentLocations = useComputedValue(() => <VPNLocation>[]);

    final handleToggleConnection = useHandleToggleConnection();

    void handleSearch(String? value) {
      final keyword = value?.trim() ?? '';
      if (locationsStore.searchKeyword != keyword) {
        locationsStore.setLocationKeyword(
          keyword,
          keyword.isEmpty ? Duration.zero : const Duration(milliseconds: 500),
        );
      }
    }

    void handleSetLocationType(IPType value) {
      ref.read(homeStateProvider.notifier).ipType = value;
    }

    void handleLocationTapped(VPNLocation location) {
      handleSetLocationType(location.ipType);
      handleToggleConnection(location: location);
    }

    void handleRecentLocationTapped(VPNLocation location) {
      handleSetLocationType(location.ipType);
      handleToggleConnection(
        location: location,
        selectEvent: (connected) =>
            connected ? AnalyticsEvent.disconnectRecents : AnalyticsEvent.connectRecents,
      );
    }

    useValueChanged<IPType, void>(locationType, (_, __) {
      analyticsStore.logLocationTabOpen(locationType);
    });

    return MultiSliver(
      children: [
        LocationsSearch(onChanged: handleSearch),
        const SizedBox(height: 24),
        switch (state.status) {
          FutureStatus.pending => MultiSliver(
              children: const [
                RecentLocationsLoading(),
                SizedBox(height: 24),
                LocationsSliverLoading(),
              ],
            ),
          FutureStatus.rejected => ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 260),
              child: RetryWdiget(
                asset: Assets.globe,
                onRetry: locationsStore.fetchVPNLocations,
                text: state.error.toString(),
              ),
            ),
          FutureStatus.fulfilled => MultiSliver(
              children: [
                if (recentLocations.isNotEmpty)
                  _RecentLocations(
                    recentLocations: recentLocations,
                    onLocationTapped: handleRecentLocationTapped,
                  ),
                if (recentLocations.isNotEmpty && locations.isNotEmpty) const SizedBox(height: 24),
                if (locations.isNotEmpty)
                  _Locations(
                    locations: locations,
                    topLocations: topLocations,
                    locationType: locationType,
                    onLocationTypeChanged: handleSetLocationType,
                    onLocationTapped: handleLocationTapped,
                  ),
              ],
            ),
        },
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
  final Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          EasyText(
            LocaleKeys.recentLocations.tr(),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          RecentLocationsList(
            items: recentLocations,
            onItemPressed: onLocationTapped,
          ),
        ],
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
  final Function(IPType) onLocationTypeChanged;
  final Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(remoteConfigStorePOD);

    final typeSwitcherKey = ref.watch(homeStateProvider.select((it) => it.typeSwitcherKey));
    final dcIPs = useComputedValue(() => config.dcIPs);

    return MultiSliver(children: [
      SliverPinnedHeader(
        child: LocationTypeSwitcher(
          key: typeSwitcherKey,
          value: locationType,
          onChanged: onLocationTypeChanged,
        ),
      ),
      SliverClip(
        child: SliverStack(
          children: [
            const SliverPositioned.fill(child: LocationsContainer()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              sliver: MultiSliver(
                children: [
                  if (dcIPs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: switch (locationType) {
                        IPType.datacenter => LocationsDisclaimer.dataCenter(),
                        IPType.residential => LocationsDisclaimer.residential(),
                      },
                    ),
                  if (topLocations.isNotEmpty)
                    LocationsSliverList(
                      ipType: locationType,
                      items: topLocations,
                      onItemPressed: onLocationTapped,
                    ),
                  if (topLocations.isNotEmpty && locations.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Divider(thickness: 0.5, color: Palette.lightBlue),
                    ),
                  LocationsSliverList(
                    ipType: locationType,
                    items: locations,
                    onItemPressed: onLocationTapped,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
