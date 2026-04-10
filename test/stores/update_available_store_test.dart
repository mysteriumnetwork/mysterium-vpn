import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/store/update_available_store.dart';

import 'update_available_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>()])
void main() async {
  late UpdateAvailableStore store;
  late MockRemoteConfigStore mockRemoteConfigStore;

  setUp(() {
    mockRemoteConfigStore = MockRemoteConfigStore();

    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');

    store = UpdateAvailableStore(
      mockRemoteConfigStore,
      BuildInfo(buildNumber: 0, buildVersion: '0.0.0'),
    );
  });

  test('appUpdateAvailable returns false if current version >= latest stable', () {
    final store = UpdateAvailableStore(
      mockRemoteConfigStore,
      BuildInfo(buildNumber: 0, buildVersion: '3.0.0'),
    );
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');

    store.updateAvailabilityFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, false);
  });

  test('appUpdateAvailable returns true if current version < latest stable', () {
    final store = UpdateAvailableStore(
      mockRemoteConfigStore,
      BuildInfo(buildNumber: 0, buildVersion: '1.0.0'),
    );

    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');

    store.updateAvailabilityFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, true);
  });

  test('appUpdateAvailable returns false if useStoreVersionChecker is false', () {
    final store = UpdateAvailableStore(
      mockRemoteConfigStore,
      BuildInfo(buildNumber: 0, buildVersion: '3.0.0'),
    );

    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(false);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');

    store.updateAvailabilityFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, false);
  });

  test('appUpdateAvailable returns false if useStoreVersionChecker is false', () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(false);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');

    store.updateAvailabilityFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, true);
  });

  test(
    'appUpdateAvailable returns true if newVersionFuture is used and store version is bigger',
    () {
      final store = UpdateAvailableStore(
        mockRemoteConfigStore,
        BuildInfo(buildNumber: 0, buildVersion: '3.0.0'),
      );

      when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
      when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');

      store.updateAvailabilityFuture = ObservableFuture.value(UpdateAvailability.updateAvailable);

      expect(store.appUpdateAvailable, true);
    },
  );

  test(
    'appUpdateAvailable returns false if newVersionFuture is used and store version is smaller',
    () {
      final store = UpdateAvailableStore(
        mockRemoteConfigStore,
        BuildInfo(buildNumber: 0, buildVersion: '3.0.0'),
      );

      when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
      when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');

      store.updateAvailabilityFuture = ObservableFuture.value(
        UpdateAvailability.updateNotAvailable,
      );

      expect(store.appUpdateAvailable, false);
    },
  );

  test(
    'appUpdateAvailable returns true if newVersionFuture is used and store version is smaller but CC version is bigger',
    () {
      final store = UpdateAvailableStore(
        mockRemoteConfigStore,
        BuildInfo(buildNumber: 0, buildVersion: '3.0.0'),
      );
      when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
      when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('6.0.0');

      store.updateAvailabilityFuture = ObservableFuture.value(UpdateAvailability.updateAvailable);

      expect(store.appUpdateAvailable, true);
    },
  );
}
