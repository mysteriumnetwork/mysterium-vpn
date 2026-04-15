import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/home/views/locations_map.dart';
import 'package:mysterium_vpn/features/locations/store/latlng_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/selected_location_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/real_ip_info_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/dialogs/request_tunnel_permissions_dialog.dart';

class HomeMap extends StatefulWidget {
  const HomeMap({super.key});

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final _locationsStore = getIt<LocationsStore>();
  final _selectedLocationStore = getIt<SelectedLocationStore>();
  final _vpnStore = getIt<VpnStore>();
  final _latLngStore = getIt<LatLngStore>();
  final _realIPStore = getIt<RealIPInfoStore>();

  late final ReactionDisposer _locationClearDisposer;

  @override
  void initState() {
    super.initState();
    _locationClearDisposer = reaction((_) => _vpnStore.location, (location) {
      if (location == null) {
        return;
      }
      _handleClearSelectedLocation();
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _locationClearDisposer();
    super.dispose();
  }

  LatLng? _getCurrentIPCoordinates() {
    if (_vpnStore.connectionStatus == VpnConnectionStatus.connecting ||
        _vpnStore.connectionStatus == VpnConnectionStatus.connected) {
      final location = _vpnStore.location ?? _vpnStore.connectingLocation;
      if (location != null) {
        return _latLngStore.coordinatesForCity(location) ??
            _latLngStore.coordinatesForCountry(location.countryCode);
      }
    }
    final realCountry = _realIPStore.info?.country;
    if (realCountry != null) {
      return _latLngStore.coordinatesForCountry(realCountry);
    }
    return null;
  }

  void _handleClearSelectedLocation() {
    _selectedLocationStore.value = null;
  }

  void _handleDoubleTapLocation(VPNLocation location) {
    if ((_vpnStore.isConnected && _vpnStore.location?.id == location.id) || _vpnStore.isLoading) {
      return;
    }
    _handleToggleConnection(location: location);
    _handleClearSelectedLocation();
  }

  Future<void> _handleToggleConnection({VPNLocation? location, UserIntent? intent}) async {
    final vpnStore = getIt<VpnStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final logEvent = vpnStore.isConnected
        ? analyticsStore.logDisconnect
        : analyticsStore.logConnect;
    logEvent(location, intent: intent);
    try {
      await vpnStore.manageConnection(location: location, intent: intent);
    } on AuthenticationRequiredException catch (_) {
      if (mounted) {
        Beamer.of(context).beamToNamed(Routes.platformLogin.path);
      }
    } on SubscriptionRequiredException catch (_) {
      await _handleSubscribe();
    } on TunnelSetupRequiredException catch (_) {
      final permissionsGiven = await _handleSetupTunnel();
      if (permissionsGiven) {
        await vpnStore.manageConnection(location: location, intent: intent);
      }
    }
  }

  Future<void> _handleSubscribe({bool manageSubscription = false}) async {
    final sessionStore = getIt<AuthSessionStore>();
    final subscriptionStore = getIt<SubscriptionStore>();
    final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();
    final accessToken = sessionStore.accessToken;
    try {
      final subscription = await subscriptionStore.subscriptionFuture;
      if (mounted) {
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
      }
    } on SubscriptionRequiredException catch (_) {}
  }

  Future<bool> _handleSetupTunnel() async {
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

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) {
      final selectedLocation = _selectedLocationStore.value;
      final locations = [
        ...?_locationsStore.residentialLocationsFuture.value?.allLocations,
        ...?_locationsStore.dcLocationsFuture.value?.allLocations,
      ].distinctBy((it) => it.id).toList();
      final myLocation = _getCurrentIPCoordinates();
      final connectedLocation = _vpnStore.isConnected ? _vpnStore.location : null;

      return LocationsMap(
        locations: locations,
        position: myLocation,
        selectedLocation: selectedLocation,
        connectedLocation: connectedLocation,
        onLocationPressed: (location) {
          _selectedLocationStore.value = location;
        },
        onLocationDoubleTapped: isDesktop() ? _handleDoubleTapLocation : null,
        onTapOutside: _handleClearSelectedLocation,
      );
    },
  );
}
