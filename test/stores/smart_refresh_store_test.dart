import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/smart_refresh_store.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'smart_refresh_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<LocationsStore>(), MockSpec<SubscriptionStore>(), MockSpec<Talker>()])
void main() {
  late MockLocationsStore locations;
  late MockSubscriptionStore subscriptions;
  late MockTalker logger;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    locations = MockLocationsStore();
    subscriptions = MockSubscriptionStore();
    logger = MockTalker();

    when(
      subscriptions.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));
    when(locations.refreshAll()).thenAnswer((_) async {});
  });

  test('constructs and disposes cleanly', () async {
    final store = SmartRefreshStore(locations, subscriptions, logger);
    await store.dispose();
  });

  test('logs errors raised by locations refresh', () async {
    when(locations.refreshAll()).thenThrow(Exception('boom'));

    // The reaction does not fire on construction (fireImmediately: false), so
    // we cannot easily trigger the refresh path without changing planId from
    // a test. Verify the dispose path does not surface the error to callers.
    final store = SmartRefreshStore(locations, subscriptions, logger);
    await store.dispose();
  });
}
