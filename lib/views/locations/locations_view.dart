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
    final locationType = useComputedValue(() => locationsStore.ipType);

    final stream = useComputedValue(() => locationsStore.locationsStream);

    final locations = useComputedValue(() => locationsStore.locations);
    final topLocations = useComputedValue(() => locationsStore.topLocations);
    final recentLocations = useComputedValue(() => locationsStore.recentLocations);

    final handleToggleConnection = useHandleToggleConnection();

    void handleSetLocationType(IPType value) {
      analyticsStore.logTabChange(value);
      locationsStore.setIPType(value);
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

    useValueChanged<IPType, void>(locationType, (_, __) {
      analyticsStore.logLocationTabOpen(locationType);
    });

    return MultiSliver(
      children: [
        _Body(
          stream: stream,
          recentLocations: recentLocations,
          locationType: locationType,
          locations: locations,
          topLocations: topLocations,
          onRecentLocationTapped: handleRecentLocationTapped,
          onLocationTypeChanged: handleSetLocationType,
          onLocationTapped: handleLocationTapped,
        ),
      ],
    );
  }
}

class _Body extends HookConsumerWidget {
  const _Body({
    required this.stream,
    required this.recentLocations,
    required this.locationType,
    required this.locations,
    required this.topLocations,
    required this.onRecentLocationTapped,
    required this.onLocationTypeChanged,
    required this.onLocationTapped,
  });

  final ObservableStream<VPNLocations> stream;
  final List<VPNLocation> recentLocations;
  final IPType locationType;
  final List<VPNLocation> locations;
  final List<VPNLocation> topLocations;
  final Function(VPNLocation) onRecentLocationTapped;
  final Function(IPType) onLocationTypeChanged;
  final Function(VPNLocation) onLocationTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);

    if (stream.value != null) {
      return MultiSliver(
        children: [
          if (recentLocations.isNotEmpty)
            _RecentLocations(
              recentLocations: recentLocations,
              onLocationTapped: onRecentLocationTapped,
            ),
          if (recentLocations.isNotEmpty) const SizedBox(height: 24),
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
    if (stream.status == StreamStatus.waiting) {
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
            asset: Assets.globe,
            onRetry: locationsStore.refresh,
            text: stream.error.toString(),
          ),
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
    final locationsStore = ref.watch(locationsStorePOD);

    final typeSwitcherKey = ref.watch(homeStateProvider.select((it) => it.typeSwitcherKey));
    final searchKeyword = useComputedValue(() => locationsStore.searchKeyword);

    return MultiSliver(
      children: [
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
              SliverPositioned.fill(
                child: LocationsContainer(
                  locationType: locationType,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                sliver: MultiSliver(
                  children: [
                    switch (locationType) {
                      IPType.datacenter => LocationsDisclaimer.dataCenter(),
                      IPType.residential => LocationsDisclaimer.residential(),
                    },
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
                      emptyText: searchKeyword.isEmpty
                          ? LocaleKeys.noLocations.tr()
                          : LocaleKeys.noLocationsKeyword.tr(namedArgs: {'keyword': searchKeyword}),
                    ),
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
