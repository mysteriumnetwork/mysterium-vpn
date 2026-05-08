import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  // A reusable helper to build a VPNLocation with sensible defaults.
  VPNLocation makeLocation({
    String id = 'DE',
    IPType ipType = IPType.datacenter,
    String countryCode = 'DE',
    bool isAvailable = true,
  }) => VPNLocation(
    id: id,
    ipType: ipType,
    translations: const {},
    countryCode: countryCode,
    isAvailable: isAvailable,
  );

  final activeSubscription = Subscription(active: true, expired: false, recurring: false);
  final inactiveSubscription = Subscription.empty(); // active: false

  group('LocationMode.from — connecting', () {
    test('returns connecting when isLoading and location == vpnLocation', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: true,
        vpnLocation: location,
        connectingLocation: null,
      );
      expect(result, LocationMode.connecting);
    });

    test('returns connecting when isLoading and location == connectingLocation', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: true,
        vpnLocation: null,
        connectingLocation: location,
      );
      expect(result, LocationMode.connecting);
    });

    test('does NOT return connecting when isLoading but location differs', () {
      final location = makeLocation();
      final other = makeLocation(id: 'US', countryCode: 'US');
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: true,
        vpnLocation: other,
        connectingLocation: null,
      );
      expect(result, isNot(LocationMode.connecting));
    });

    test(
      'does NOT return connecting when isLoading but both vpnLocation and connectingLocation are null',
      () {
        final location = makeLocation();
        final result = LocationMode.from(
          location: location,
          isAuthenticated: true,
          residentialIPsAllowed: true,
          unavailableLocations: const {},
          subscription: activeSubscription,
          isConnected: false,
          isLoading: true,
          vpnLocation: null,
          connectingLocation: null,
        );
        expect(result, isNot(LocationMode.connecting));
      },
    );
  });

  group('LocationMode.from — connected', () {
    test('returns connected when isConnected and location == vpnLocation', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: true,
        isLoading: false,
        vpnLocation: location,
        connectingLocation: null,
      );
      expect(result, LocationMode.connected);
    });

    test('does NOT return connected when location differs from vpnLocation', () {
      final location = makeLocation();
      final other = makeLocation(id: 'US', countryCode: 'US');
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: true,
        isLoading: false,
        vpnLocation: other,
        connectingLocation: null,
      );
      expect(result, isNot(LocationMode.connected));
    });
  });

  group('LocationMode.from — unsubscribed', () {
    test('unauthenticated user is unsubscribed regardless of subscription value', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: false,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.unsubscribed);
    });

    test('authenticated user with null subscription is unsubscribed', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: null,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.unsubscribed);
    });

    test('authenticated user with inactive subscription is unsubscribed', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: inactiveSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.unsubscribed);
    });
  });

  group('LocationMode.from — loading', () {
    test('isSubscriptionLoading shows loading even when subscription is empty', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: inactiveSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
        isSubscriptionLoading: true,
      );
      expect(result, LocationMode.loading);
    });

    test('unauthenticated short-circuits to unsubscribed even when isSubscriptionLoading', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: false,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: null,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
        isSubscriptionLoading: true,
      );
      expect(result, LocationMode.unsubscribed);
    });
  });

  group('LocationMode.from — unsupportedByPlan', () {
    test(
      'returns unsupportedByPlan for residential location when residentialIPsAllowed is false',
      () {
        final location = makeLocation(ipType: IPType.residential);
        final result = LocationMode.from(
          location: location,
          isAuthenticated: true,
          residentialIPsAllowed: false,
          unavailableLocations: const {},
          subscription: activeSubscription,
          isConnected: false,
          isLoading: false,
          vpnLocation: null,
          connectingLocation: null,
        );
        expect(result, LocationMode.unsupportedByPlan);
      },
    );

    test(
      'datacenter location is never unsupportedByPlan even when residentialIPsAllowed is false',
      () {
        final location = makeLocation();
        final result = LocationMode.from(
          location: location,
          isAuthenticated: true,
          residentialIPsAllowed: false,
          unavailableLocations: const {},
          subscription: activeSubscription,
          isConnected: false,
          isLoading: false,
          vpnLocation: null,
          connectingLocation: null,
        );
        expect(result, LocationMode.available);
      },
    );
  });

  group('LocationMode.from — unavailable', () {
    test('returns unavailable when datacenter is in unavailableLocations', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: {location},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.unavailable);
    });

    test('returns unavailable when datacenter location.isAvailable is false', () {
      final location = makeLocation(isAvailable: false);
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.unavailable);
    });

    test(
      'returns unavailable for residential location that plan supports but server flagged unavailable',
      () {
        final location = makeLocation(ipType: IPType.residential, isAvailable: false);
        final result = LocationMode.from(
          location: location,
          isAuthenticated: true,
          residentialIPsAllowed: true,
          unavailableLocations: const {},
          subscription: activeSubscription,
          isConnected: false,
          isLoading: false,
          vpnLocation: null,
          connectingLocation: null,
        );
        expect(result, LocationMode.unavailable);
      },
    );

    test('unavailable takes precedence over unsupportedByPlan for residential locations', () {
      final location = makeLocation(ipType: IPType.residential, isAvailable: false);
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: false,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.unavailable);
    });
  });

  group('LocationMode.from — available', () {
    test('returns available when all checks pass', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: false,
        isLoading: false,
        vpnLocation: null,
        connectingLocation: null,
      );
      expect(result, LocationMode.available);
    });

    test(
      'returns available for residential location when residentialIPsAllowed and isAvailable',
      () {
        final location = makeLocation(ipType: IPType.residential);
        final result = LocationMode.from(
          location: location,
          isAuthenticated: true,
          residentialIPsAllowed: true,
          unavailableLocations: const {},
          subscription: activeSubscription,
          isConnected: false,
          isLoading: false,
          vpnLocation: null,
          connectingLocation: null,
        );
        expect(result, LocationMode.available);
      },
    );
  });

  group('LocationMode.from — priority ordering', () {
    test('connecting takes precedence over connected (isLoading + isConnected both true)', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: activeSubscription,
        isConnected: true,
        isLoading: true,
        vpnLocation: location,
        connectingLocation: null,
      );
      expect(result, LocationMode.connecting);
    });

    test('connected takes precedence over unsubscribed', () {
      final location = makeLocation();
      // Even with no subscription, a connected+matching location is "connected".
      final result = LocationMode.from(
        location: location,
        isAuthenticated: true,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: null,
        isConnected: true,
        isLoading: false,
        vpnLocation: location,
        connectingLocation: null,
      );
      expect(result, LocationMode.connected);
    });

    test('connected takes precedence over unauthenticated unsubscribed', () {
      final location = makeLocation();
      final result = LocationMode.from(
        location: location,
        isAuthenticated: false,
        residentialIPsAllowed: true,
        unavailableLocations: const {},
        subscription: null,
        isConnected: true,
        isLoading: false,
        vpnLocation: location,
        connectingLocation: null,
      );
      expect(result, LocationMode.connected);
    });
  });
}
