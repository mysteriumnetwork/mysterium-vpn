// dart
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:vpn_api/vpn_api.dart' as vpn_api;

import 'subscription_store_test.mocks.dart';

IosDeviceInfo _mockIosDeviceInfo({String systemVersion = '17.0'}) => IosDeviceInfo.fromMap({
  'name': 'Test iPhone',
  'systemName': 'iOS',
  'systemVersion': systemVersion,
  'model': 'iPhone',
  'modelName': 'iPhone 15',
  'localizedModel': 'iPhone',
  'identifierForVendor': 'test-uuid',
  'freeDiskSize': 0,
  'totalDiskSize': 0,
  'isPhysicalDevice': false,
  'physicalRamSize': 0,
  'availableRamSize': 0,
  'isiOSAppOnMac': false,
  'isiOSAppOnVision': false,
  'utsname': {
    'sysname': 'Darwin',
    'nodename': 'test',
    'release': '21.0.0',
    'version': 'test',
    'machine': 'iPhone14,2',
  },
});

Future<void> _initEnvWithIosVersion(
  MockDeviceInfoPlugin mockPlugin, {
  String version = '17.0',
}) async {
  when(mockPlugin.deviceInfo).thenAnswer((_) async => _mockIosDeviceInfo(systemVersion: version));
  await Env.initDeviceInfo(mockPlugin);
}

@GenerateNiceMocks([
  MockSpec<vpn_api.VpnApi>(),
  MockSpec<SubscriptionService>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<DeviceInfoPlugin>(),
  MockSpec<SubscriptionConfigStore>(),
])
void main() {
  late SubscriptionStore subscriptionStore;
  late MockVpnApi mockVpnApi;
  late MockSubscriptionService mockSubscriptionService;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockDeviceInfoPlugin mockDeviceInfoPlugin;
  late MockSubscriptionConfigStore mockConfigStore;

  final subscriptionExpired = Subscription(
    active: false,
    activeUntil: DateTime.now().subtract(const Duration(days: 1)),
    expired: true,
    recurring: false,
  );

  vpn_api.SubscriptionConfigResponse config() => vpn_api.SubscriptionConfigResponse(
    gateways: [],
    plans: [],
    countries: [],
    stripePublishableKey: '',
    stripeReturnUrl: '',
  );

  setUp(() async {
    mockVpnApi = MockVpnApi();
    mockSubscriptionService = MockSubscriptionService();
    mockAuthSessionStore = MockAuthSessionStore();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockDeviceInfoPlugin = MockDeviceInfoPlugin();
    mockConfigStore = MockSubscriptionConfigStore();

    await _initEnvWithIosVersion(mockDeviceInfoPlugin);

    when(mockRemoteConfigStore.hideReedemCode).thenReturn(false);
    when(mockAuthSessionStore.isAuthenticated).thenReturn(false);
    when(
      mockSubscriptionService.fetchSubscriptionDetails(),
    ).thenAnswer((_) async => subscriptionExpired);

    // Stub config store with a fulfilled config by default.
    when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config()));
    when(mockConfigStore.refreshConfig()).thenAnswer((_) async => config());

    subscriptionStore = SubscriptionStore(
      api: mockVpnApi,
      subscriptionService: mockSubscriptionService,
      authSessionStore: mockAuthSessionStore,
      analyticsStore: mockAnalyticsStore,
      remoteConfigStore: mockRemoteConfigStore,
      configStore: mockConfigStore,
    );

    clearInteractions(mockSubscriptionService);
    clearInteractions(mockAuthSessionStore);
    clearInteractions(mockAnalyticsStore);
  });

  group('SubscriptionStore', () {
    test('fetches subscription config successfully', () async {
      when(mockConfigStore.refreshConfig()).thenAnswer((_) async => config());
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(config()));

      await subscriptionStore.refreshSubscriptionConfig();

      expect(subscriptionStore.storeState, StoreState.available);
      verify(mockConfigStore.refreshConfig()).called(1);
    });

    test('handles subscription config fetch failure (NotAvailableException)', () async {
      when(mockConfigStore.refreshConfig()).thenAnswer((_) async => null);
      when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));

      await subscriptionStore.refreshSubscriptionConfig();

      expect(subscriptionStore.storeState, StoreState.notAvailable);
      verify(mockConfigStore.refreshConfig()).called(1);
    });

    test('refreshSubscription triggers fetch when last value is inactive', () async {
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

      // First refresh returns inactive, second returns active.
      final inactive = Subscription(
        active: false,
        activeUntil: DateTime.now().subtract(const Duration(days: 1)),
        expired: true,
        recurring: false,
      );
      final active = Subscription(
        active: true,
        activeUntil: DateTime.now().add(const Duration(days: 30)),
        expired: false,
        recurring: true,
      );

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => inactive);
      await subscriptionStore.refreshSubscription();
      expect(subscriptionStore.isSubscribed, false);

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => active);
      await subscriptionStore.refreshSubscription();

      expect(subscriptionStore.isSubscribed, true);
      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(2);
    });

    test('refreshSubscription does not refetch when already active and not rejected', () async {
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

      final active = Subscription(
        active: true,
        activeUntil: DateTime.now().add(const Duration(days: 30)),
        expired: false,
        recurring: true,
      );

      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => active);

      await subscriptionStore.refreshSubscription();
      expect(subscriptionStore.isSubscribed, true);

      await subscriptionStore.refreshSubscription();
      expect(subscriptionStore.isSubscribed, true);

      // Only the initial call should happen; second refresh should not refetch.
      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(1);
    });

    test('mockSubscriptionFailureStatus makes refreshSubscription refetch', () async {
      when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

      subscriptionStore.mockSubscriptionFailureStatus();

      final active = Subscription(
        active: true,
        activeUntil: DateTime.now().add(const Duration(days: 30)),
        expired: false,
        recurring: true,
      );
      when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => active);

      await subscriptionStore.refreshSubscription();

      expect(subscriptionStore.isSubscribed, true);
      verify(mockSubscriptionService.fetchSubscriptionDetails()).called(1);
    });

    test(
      'refreshSubscription sets analytics user properties for planId, validTo, userStatus, gateway',
      () async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);

        final paid = Subscription(
          active: true,
          activeUntil: DateTime.now().add(const Duration(days: 7)),
          expired: false,
          recurring: true,
          planId: 'plan_123',
          gateway: 'Stripe',
        );
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer((_) async => paid);

        await subscriptionStore.refreshSubscription();

        final captured = verify(
          mockAnalyticsStore.setUserProperty(captureAny),
        ).captured.cast<AnalyticsUserProperty>();
        // planId, validTo, userStatus, gateway.
        expect(captured.length, 4);
        final gatewayProp = captured.firstWhere(
          (p) => p.rawName == AnalyticsUserPropName.gateway.formattedName,
        );
        // Gateway is normalised to lower-case.
        expect(gatewayProp.value, 'stripe');
      },
    );

    group('canRedeemCode', () {
      test('returns false when hideReedemCode remote config is true', () async {
        subscriptionStore.testIsIOS = true;
        when(mockRemoteConfigStore.hideReedemCode).thenReturn(true);

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns false on non-iOS platform', () async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => Subscription.empty());

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns true when no active subscription on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => Subscription.empty());

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isTrue);
      });

      test('returns true when active subscription with apple gateway on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription(
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
            gateway: 'apple',
          ),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isTrue);
      });

      test('returns false when active subscription with non-apple gateway on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription(
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
            gateway: 'stripe',
          ),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns false when active subscription with null gateway on iOS', () async {
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(mockSubscriptionService.fetchSubscriptionDetails()).thenAnswer(
          (_) async => Subscription(
            active: true,
            activeUntil: DateTime.now().add(const Duration(days: 30)),
            expired: false,
            recurring: true,
          ),
        );

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns false when iOS version is below 14', () async {
        await _initEnvWithIosVersion(mockDeviceInfoPlugin, version: '13.7');
        subscriptionStore.testIsIOS = true;

        expect(subscriptionStore.canRedeemCode, isFalse);
      });

      test('returns true when iOS version is exactly 14', () async {
        await _initEnvWithIosVersion(mockDeviceInfoPlugin, version: '14.0');
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => Subscription.empty());

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isTrue);
      });

      test('returns true when iOS version is above 14', () async {
        await _initEnvWithIosVersion(mockDeviceInfoPlugin, version: '18.3.1');
        subscriptionStore.testIsIOS = true;
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => Subscription.empty());

        await subscriptionStore.refreshSubscription();

        expect(subscriptionStore.canRedeemCode, isTrue);
      });

      test('returns false when deviceInfo is not IosDeviceInfo', () async {
        when(mockDeviceInfoPlugin.deviceInfo).thenAnswer((_) async => BaseDeviceInfo({}));
        await Env.initDeviceInfo(mockDeviceInfoPlugin);
        subscriptionStore.testIsIOS = true;

        expect(subscriptionStore.canRedeemCode, isFalse);
      });
    });

    group('useWebFlow', () {
      Future<void> primeSubscription(Subscription subscription) async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => subscription);
        await subscriptionStore.refreshSubscription();
      }

      test('returns true on Windows with no active subscription (first-time buyer)', () async {
        subscriptionStore.testIsWindows = true;
        expect(subscriptionStore.useWebFlow, isTrue);
      });

      test('returns false for active store sub on Windows (managed in store, not web)', () async {
        subscriptionStore.testIsWindows = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'apple', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.useWebFlow, isFalse);
      });

      test('returns true for active web (stripe) sub on Windows', () async {
        subscriptionStore.testIsWindows = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'stripe', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.useWebFlow, isTrue);
      });

      test('returns false when subscription is inactive', () async {
        await primeSubscription(Subscription.empty());
        expect(subscriptionStore.useWebFlow, isFalse);
      });

      test('returns false for active apple sub (any platform)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'apple', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.useWebFlow, isFalse);
      });

      test('returns false for active google sub (any platform)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'google', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.useWebFlow, isFalse);
      });

      test('returns true for active stripe sub (credit card -> web)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'stripe', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.useWebFlow, isTrue);
      });

      test('returns true for active adyen sub (credit card -> web)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'adyen', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.useWebFlow, isTrue);
      });

      test('returns true for active paypal sub', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'paypal', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.useWebFlow, isTrue);
      });

      test('returns true for active coingate sub', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'coingate', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.useWebFlow, isTrue);
      });
    });

    group('isStoreSubOnForeignPlatform', () {
      Future<void> primeSubscription(Subscription subscription) async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => subscription);
        await subscriptionStore.refreshSubscription();
      }

      test('returns false when subscription is inactive', () async {
        subscriptionStore.testIsWindows = true;
        await primeSubscription(Subscription.empty());
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isFalse);
      });

      test('returns false for active web (stripe) sub on any platform', () async {
        subscriptionStore.testIsWindows = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'stripe', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isFalse);
      });

      test('returns true for apple sub on Windows', () async {
        subscriptionStore.testIsWindows = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'apple', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isTrue);
      });

      test('returns true for apple sub on Android', () async {
        subscriptionStore.testIsAndroid = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'apple', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isTrue);
      });

      test('returns false for apple sub on iOS (matching store)', () async {
        subscriptionStore.testIsIOS = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'apple', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isFalse);
      });

      test('returns false for apple sub on macOS (matching store)', () async {
        subscriptionStore.testIsMacOS = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'apple', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isFalse);
      });

      test('returns true for google sub on Windows', () async {
        subscriptionStore.testIsWindows = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'google', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isTrue);
      });

      test('returns true for google sub on iOS', () async {
        subscriptionStore.testIsIOS = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'google', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isTrue);
      });

      test('returns false for google sub on Android (matching store)', () async {
        subscriptionStore.testIsAndroid = true;
        await primeSubscription(
          Subscription(active: true, gateway: 'google', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isStoreSubOnForeignPlatform, isFalse);
      });
    });

    group('isOnMaxPlan', () {
      late vpn_api.SubscriptionConfigResponse configWithPlans;

      vpn_api.SubscriptionConfigResponsePlansInner plan({
        required String id,
        required List<String> supportedGateways,
        String intervalUnit = 'month',
        int intervalAmount = 1,
      }) => vpn_api.SubscriptionConfigResponsePlansInner(
        id: id,
        interval: vpn_api.SubscriptionConfigResponsePlansInnerInterval(
          unit: vpn_api.SubscriptionConfigResponsePlansInnerIntervalUnitEnum.values.firstWhere(
            (u) => u.value == intervalUnit,
          ),
          amount: intervalAmount,
        ),
        price: vpn_api.SubscriptionConfigResponsePlansInnerPrice(USD: 0),
        prices: const [],
        supportedGateways: supportedGateways,
        metadata: vpn_api.SubscriptionConfigResponsePlansInnerMetadata(),
      );

      setUp(() {
        configWithPlans = vpn_api.SubscriptionConfigResponse(
          gateways: const [],
          plans: [
            plan(id: 'plan_yearly_plus', supportedGateways: ['google'], intervalUnit: 'year'),
            plan(
              id: 'plan_2_years_pro',
              supportedGateways: ['stripe', 'primer'],
              intervalUnit: 'year',
              intervalAmount: 2,
            ),
            plan(
              id: 'plan_yearly_pro',
              supportedGateways: ['stripe', 'primer'],
              intervalUnit: 'year',
            ),
          ],
          countries: const [],
          stripePublishableKey: '',
          stripeReturnUrl: '',
        );
        when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(configWithPlans));
        // Production planFeatures only lists the in-app sellable tiers (Basic,
        // Plus); Pro is web-only and absent. The intrinsic tier order must
        // still rank the 2-year Pro plan as the max.
        when(mockRemoteConfigStore.planFeatures).thenReturn([
          SubscriptionPlanFeatures(
            name: 'Basic',
            planIds: {'plan_monthly_basic', 'plan_yearly_basic'},
            previewFeatures: const {},
            detailedFeatures: const {},
          ),
          SubscriptionPlanFeatures(
            name: 'Plus',
            planIds: {'plan_monthly_plus', 'plan_yearly_plus'},
            previewFeatures: const {},
            detailedFeatures: const {},
          ),
        ]);
      });

      Future<void> primeSubscription(Subscription subscription) async {
        when(mockAuthSessionStore.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionService.fetchSubscriptionDetails(),
        ).thenAnswer((_) async => subscription);
        await subscriptionStore.refreshSubscription();
        await subscriptionStore.refreshSubscriptionConfig();
      }

      test('returns false when subscription is inactive', () async {
        await primeSubscription(Subscription.empty());
        expect(subscriptionStore.isOnMaxPlan, isFalse);
      });

      test('returns true when google sub is on yearly Plus (mobile max)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'google', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isOnMaxPlan, isTrue);
      });

      test('returns true when stripe sub is on 2-year Pro (web max)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'stripe', planId: 'plan_2_years_pro'),
        );
        expect(subscriptionStore.isOnMaxPlan, isTrue);
      });

      test('returns false when stripe sub is on yearly Pro (1-year < 2-year)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'stripe', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.isOnMaxPlan, isFalse);
      });

      test('returns true for primer sub on 2-year Pro (web max, like any web gateway)', () async {
        // Primer is a normal web gateway in supportedGateways; the 2-year Pro
        // plan ranks as the max via the intrinsic tier order, even though
        // planFeatures has no Pro tier.
        await primeSubscription(
          Subscription(active: true, gateway: 'primer', planId: 'plan_2_years_pro'),
        );
        expect(subscriptionStore.isOnMaxPlan, isTrue);
      });

      test('returns false for primer sub on a lower plan (upgrade still possible)', () async {
        await primeSubscription(
          Subscription(active: true, gateway: 'primer', planId: 'plan_yearly_pro'),
        );
        expect(subscriptionStore.isOnMaxPlan, isFalse);
      });

      test('returns false when config is missing', () async {
        when(mockConfigStore.future).thenAnswer((_) => ObservableFuture.value(null));
        when(mockConfigStore.refreshConfig()).thenAnswer((_) async => null);
        await primeSubscription(
          Subscription(active: true, gateway: 'google', planId: 'plan_yearly_plus'),
        );
        expect(subscriptionStore.isOnMaxPlan, isFalse);
      });
    });
  });
}
