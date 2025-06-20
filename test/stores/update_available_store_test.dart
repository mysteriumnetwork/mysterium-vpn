import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/stores/update_availabe_store.dart';
import 'package:new_version_plus/new_version_plus.dart';

import 'update_available_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RemoteConfigStore>(),
  MockSpec<NewVersionPlus>(),
  MockSpec<FlavorConfig>(),
])
void main() {
  late UpdateAvailableStore store;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockNewVersionPlus mockNewVersionPlus;
  late MockFlavorConfig mockFlavorConfig;

  setUp(() {
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockNewVersionPlus = MockNewVersionPlus();
    mockFlavorConfig = MockFlavorConfig();

    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '0.0.0'));

    store = UpdateAvailableStore(
      mockRemoteConfigStore,
      mockNewVersionPlus,
      mockFlavorConfig,
    );
  });

  test('appUpdateAvailable returns false if current version >= latest stable', () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '3.0.0'));

    store.newVersionFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, false);
  });

  test('appUpdateAvailable returns true if current version < latest stable', () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '1.0.0'));

    store.newVersionFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, true);
  });

  test('appUpdateAvailable returns false if useStoreVersionChecker is false', () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(false);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '3.0.0'));

    store.newVersionFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, false);
  });

  test('appUpdateAvailable returns false if useStoreVersionChecker is false', () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(false);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('2.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '1.0.0'));

    store.newVersionFuture = ObservableFuture.value(null);

    expect(store.appUpdateAvailable, true);
  });

  test('appUpdateAvailable returns true if newVersionFuture is used and store version is bigger',
      () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '3.0.0'));

    store.newVersionFuture = ObservableFuture.value(
      VersionStatus(
        storeVersion: '4.0.0',
        localVersion: '3.0.0',
        appStoreLink: '',
      ),
    );

    expect(store.appUpdateAvailable, true);
  });

  test('appUpdateAvailable returns false if newVersionFuture is used and store version is smaller',
      () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('0.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '3.0.0'));

    store.newVersionFuture = ObservableFuture.value(
      VersionStatus(
        storeVersion: '2.0.0',
        localVersion: '3.0.0',
        appStoreLink: '',
      ),
    );

    expect(store.appUpdateAvailable, false);
  });

  test(
      'appUpdateAvailable returns true if newVersionFuture is used and store version is smaller but CC version is bigger',
      () {
    when(mockRemoteConfigStore.useStoreVersionChecker).thenReturn(true);
    when(mockRemoteConfigStore.latestStableAppVersion).thenReturn('6.0.0');
    when(mockFlavorConfig.buildInfo).thenReturn(BuildInfo(buildNumber: 0, buildVersion: '3.0.0'));

    store.newVersionFuture = ObservableFuture.value(
      VersionStatus(
        storeVersion: '0.0.0',
        localVersion: '3.0.0',
        appStoreLink: '',
      ),
    );

    expect(store.appUpdateAvailable, true);
  });
}
