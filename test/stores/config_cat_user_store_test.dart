import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_user_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker/talker.dart';

import 'config_cat_user_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthSessionStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<Talker>(),
])
void main() {
  late MockAuthSessionStore session;
  late MockRealIPInfoStore ipInfo;
  late MockSubscriptionStore subscription;
  late MockTalker logger;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PackageInfo.setMockInitialValues(
      appName: 'mysterium_vpn',
      packageName: 'com.mysteriumvpn.test',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
    await Env.init();
  });

  setUp(() {
    session = MockAuthSessionStore();
    ipInfo = MockRealIPInfoStore();
    subscription = MockSubscriptionStore();
    logger = MockTalker();

    when(
      session.userFuture,
    ).thenAnswer((_) => ObservableFuture.value(AuthUser(userId: 'u1', username: 'u@e.com')));
    when(ipInfo.infoFuture).thenAnswer(
      (_) => ObservableFuture.value(const IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1')),
    );
    when(
      subscription.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
  });

  test('builds a stringified user from session, IP info, and subscription', () async {
    final store = ConfigCatUserStore(session, ipInfo, subscription, logger);
    await store.future;

    expect(store.user, isNotNull);
    expect(store.user, contains('u1'));
    expect(store.user, contains('u@e.com'));
    expect(store.user, contains('US'));
  });

  test('falls back to empty user data when session lookup fails', () async {
    when(session.userFuture).thenAnswer((_) => ObservableFuture.error(Exception('boom')));

    final store = ConfigCatUserStore(session, ipInfo, subscription, logger);
    await store.future;

    expect(store.user, isNotNull);
    verify(logger.handle(any, any)).called(greaterThanOrEqualTo(1));
  });

  test('dispose disposes reactions cleanly', () async {
    final store = ConfigCatUserStore(session, ipInfo, subscription, logger);
    await store.future;
    await store.dispose();
  });
}
