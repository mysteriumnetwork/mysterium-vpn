import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/locations/store/locations_query_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/recent_locations_store.dart';
import 'package:mysterium_vpn/features/locations/views/components/location_item_empty.dart';
import 'package:mysterium_vpn/features/locations/views/components/location_type_switcher.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_container.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_disclaimer.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_horizontal_list.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_sliver_list.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_sliver_loading.dart';
import 'package:mysterium_vpn/features/locations/views/components/recent_locations_loading.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/user_intents_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/dialogs/request_tunnel_permissions_dialog.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/retry_widget.dart';
import 'package:mysterium_vpn/shared/components/user_intent_picker.dart';
import 'package:mysterium_vpn/shared/components/user_intent_tooltip.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:sliver_tools/sliver_tools.dart';

class LocationsSliverView extends StatelessWidget {
  const LocationsSliverView({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsStore = getIt<AnalyticsStore>();
    final locationsStore = getIt<LocationsStore>();
    final recentLocationsStore = getIt<RecentLocationsStore>();
    final locationsQueryStore = getIt<LocationsQueryStore>();

    void handleSetLocationType(IPType value) {
      analyticsStore.logTabChange(value);
      locationsQueryStore.setIPType(value);
    }

    void handleLocationTapped(VPNLocation location) {
      _handleToggleConnection(context, location: location);
    }

    void handleRecentLocationTapped(VPNLocation location) {
      _handleToggleConnection(
        context,
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

class _Body extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final vpnStore = getIt<VpnStore>();
    final locationsStore = getIt<LocationsStore>();
    final recentLocationsStore = getIt<RecentLocationsStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();
    final userIntentsStore = getIt<UserIntentsStore>();
    final authSessionStore = getIt<AuthSessionStore>();

    return Observer(
      builder: (context) {
        final connectedLocation = vpnStore.isConnected ? vpnStore.location : null;
        final isAuthenticated = authSessionStore.status == AuthStatus.authenticated;
        final recentsFutureStatus = recentLocationsStore.future.status;
        final showUserIntents =
            remoteConfigStore.showUserIntents &&
            (userIntentsStore.intents.isNotEmpty ||
                userIntentsStore.intentsFuture.status == FutureStatus.pending);
        final theme = Theme.of(context);
        final screenType = getScreenType(MediaQuery.sizeOf(context));
        final horizontalPadding = screenType >= ScreenType.desktop
            ? theme.spacing.xl3
            : screenType >= ScreenType.tablet
            ? theme.spacing.xl3
            : 0.0;
        final sectionGap = screenType >= ScreenType.tablet ? theme.spacing.xl3 : theme.spacing.md;

        if (future.value != null) {
          return MultiSliver(
            children: [
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
              if (showUserIntents) const SizedBox(height: 20),
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
      },
    );
  }
}

class _UserIntent extends StatelessWidget {
  const _UserIntent();

  @override
  Widget build(BuildContext context) {
    final vpnStore = getIt<VpnStore>();
    final userIntentsStore = getIt<UserIntentsStore>();
    final locationsStore = getIt<LocationsStore>();

    return Observer(
      builder: (context) {
        final locationsEmpty = locationsStore.isEmpty;
        final isLoading =
            vpnStore.connectionStatus == VpnConnectionStatus.connecting ||
            vpnStore.connectionStatus == VpnConnectionStatus.disconnecting;

        final intents = userIntentsStore.intentsFuture.value;
        final selected = userIntentsStore.userIntent;
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
                    style: theme.textStyles.textMd.semibold.copyWith(
                      color: theme.palette.textTertiary,
                    ),
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
                  : (value) => _handleToggleConnection(context, intent: value),
              value: selected,
            ),
          ],
        );
      },
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

class _Locations extends StatefulWidget {
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
  State<_Locations> createState() => _LocationsState();
}

class _LocationsState extends State<_Locations> {
  final _locationsQueryStore = getIt<LocationsQueryStore>();
  final _locationsStore = getIt<LocationsStore>();
  final _vpnStore = getIt<VpnStore>();
  late final ReactionDisposer _autoSelectDisposer;
  final _stickyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _autoSelectDisposer = reaction(
      (_) => (_vpnStore.location?.id, _vpnStore.location?.ipType, _locationsStore.locationTypes),
      (data) {
        final (location, ipType, availableTypes) = data;
        if ((location != null && ipType == null) || ipType == IPType.closest) {
          return;
        }
        final previous = _locationsQueryStore.ipType;
        final selected = availableTypes.contains(ipType)
            ? ipType
            : availableTypes.contains(previous)
            ? previous
            : availableTypes.firstOrNull;
        if (selected == null) {
          return;
        }
        _locationsQueryStore.setIPType(selected);
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _autoSelectDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final innerHorizontalPadding = screenType >= ScreenType.tablet ? 32.0 : 0.0;

    return Observer(
      builder: (context) {
        final typeSwitcherKey = HomeStateScope.of(context).typeSwitcherKey;
        final locationsKey = HomeStateScope.of(context).locationsKey;
        final searchKeyword = _locationsQueryStore.searchTrimmed;
        final isEmpty = _locationsStore.isEmpty;

        return MultiSliver(
          children: [
            SliverPinnedHeader(
              child: SizedBox(
                key: _stickyKey,
                child: Observer(
                  builder: (context) => LocationTypeSwitcher(
                    key: typeSwitcherKey,
                    value: widget.locationType,
                    options: _locationsStore.locationTypes,
                    onChanged: widget.onLocationTypeChanged,
                  ),
                ),
              ),
            ),
            SliverClip(
              child: SliverStack(
                children: [
                  SliverPositioned.fill(
                    child: LocationsContainer(key: locationsKey, locationType: widget.locationType),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: innerHorizontalPadding, vertical: 20),
                    sliver: MultiSliver(
                      children: [
                        switch (widget.locationType) {
                          IPType.datacenter => LocationsDisclaimer.dataCenter(),
                          _ => LocationsDisclaimer.residential(),
                        },
                        ScrollableLocationsSliverList(
                          items: widget.locations,
                          onItemPressed: widget.onLocationTapped,
                          stickyHeaderKey: _stickyKey,
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
      },
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

// ---------------------------------------------------------------------------
// Shared helper: inline of useHandleToggleConnection
// ---------------------------------------------------------------------------

Future<void> _handleToggleConnection(
  BuildContext context, {
  VPNLocation? location,
  UserIntent? intent,
  AnalyticsEventSelector? selectEvent,
}) async {
  final vpnStore = getIt<VpnStore>();
  final analyticsStore = getIt<AnalyticsStore>();
  final logEvent = vpnStore.isConnected ? analyticsStore.logDisconnect : analyticsStore.logConnect;
  logEvent(location, event: selectEvent?.call(vpnStore.isConnected), intent: intent);

  try {
    await vpnStore.manageConnection(location: location, intent: intent);
  } on AuthenticationRequiredException catch (_) {
    if (context.mounted) {
      Beamer.of(context).beamToNamed(Routes.platformLogin.path);
    }
  } on SubscriptionRequiredException catch (_) {
    if (context.mounted) {
      await _handleSubscribe(context);
    }
  } on TunnelSetupRequiredException catch (_) {
    if (context.mounted) {
      final permissionsGiven = await _handleSetupTunnel(context);
      if (permissionsGiven) {
        await vpnStore.manageConnection(location: location, intent: intent);
      }
    }
  }
}

Future<void> _handleSubscribe(BuildContext context, {bool manageSubscription = false}) async {
  final sessionStore = getIt<AuthSessionStore>();
  final subscriptionStore = getIt<SubscriptionStore>();
  final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
  final remoteConfigStore = getIt<RemoteConfigStore>();
  final accessToken = sessionStore.accessToken;
  try {
    final subscription = await subscriptionStore.subscriptionFuture;
    if (!context.mounted) {
      return;
    }
    await handleOnBillingPage(
      context: context,
      manageSubscriptionPage: remoteConfigStore.manageSubscriptionPage,
      upgradeSubscriptionPage: remoteConfigStore.upgradeSubscriptionPage,
      gateway: subscription.gateway,
      subscriptionActive: subscription.active,
      accessToken: accessToken,
      onManageSubscription: subscriptionPurchaseStore.manageSubscription,
      manageSubscription: manageSubscription,
    );
  } on SubscriptionRequiredException catch (_) {}
}

Future<bool> _handleSetupTunnel(BuildContext context) async {
  final abTestingStore = getIt<ABTestingStore>();
  final vpnStore = getIt<VpnStore>();
  final tunnelConsentType = abTestingStore.tunnelConsentType;
  final permissionsGranted = await showRequestTunnelPermissionsDialog(context, tunnelConsentType);
  if (permissionsGranted ?? false) {
    await vpnStore.setupTunnel();
    return true;
  }
  return false;
}

// ignore: avoid_positional_boolean_parameters
typedef AnalyticsEventSelector = AnalyticsEvent Function(bool connected);
