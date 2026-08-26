import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'handle_toggle_connection_hook_test.mocks.dart';

const _location = VPNLocation(
  id: 'de',
  ipType: IPType.datacenter,
  translations: {},
  countryCode: 'de',
);

@GenerateNiceMocks([
  MockSpec<VpnStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<SubscriptionStore>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockVpnStore vpnStore;
  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;

  setUp(() {
    vpnStore = MockVpnStore();
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    when(vpnStore.isConnected).thenReturn(false);
    when(subscriptionStore.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(Subscription(active: true, id: 'sub-1', paused: true)),
    );
    when(
      analyticsStore.logSubscriptionResumeStarted(
        subscriptionId: anyNamed('subscriptionId'),
        pauseEndDate: anyNamed('pauseEndDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logSubscriptionResumeCompleted(
        subscriptionId: anyNamed('subscriptionId'),
        subscriptionStatusBefore: anyNamed('subscriptionStatusBefore'),
        subscriptionStatusAfter: anyNamed('subscriptionStatusAfter'),
        billingResumeDate: anyNamed('billingResumeDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logSubscriptionResumeFailed(
        subscriptionId: anyNamed('subscriptionId'),
        failureReason: anyNamed('failureReason'),
      ),
    ).thenAnswer((_) async {});
  });

  /// Mounts a host that invokes the hook for [_location] when tapped.
  Future<void> pumpHost(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vpnStorePOD.overrideWithValue(vpnStore),
          analyticsStorePOD.overrideWithValue(analyticsStore),
          subscriptionStorePOD.overrideWithValue(subscriptionStore),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: const Scaffold(body: _Host()),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('toggle'));
    await tester.pumpAndSettle();
  }

  testWidgets('a paused subscription surfaces the resume prompt', (tester) async {
    when(
      vpnStore.manageConnection(
        location: anyNamed('location'),
        intent: anyNamed('intent'),
        targetIp: anyNamed('targetIp'),
      ),
    ).thenThrow(const SubscriptionPausedException());

    await pumpHost(tester);

    expect(find.text(S.current.resumeSubscriptionTitle), findsOneWidget);
  });

  testWidgets('resuming from the prompt retries the connection', (tester) async {
    var attempts = 0;
    when(
      vpnStore.manageConnection(
        location: anyNamed('location'),
        intent: anyNamed('intent'),
        targetIp: anyNamed('targetIp'),
      ),
    ).thenAnswer((_) async {
      attempts++;
      if (attempts == 1) {
        throw const SubscriptionPausedException();
      }
    });
    when(subscriptionStore.resumeSubscription()).thenAnswer((_) async {
      when(
        subscriptionStore.subscriptionFuture,
      ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true, id: 'sub-1')));
    });

    await pumpHost(tester);
    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    verify(subscriptionStore.resumeSubscription()).called(1);
    expect(attempts, 2, reason: 'the connection should be retried after a successful resume');
    expect(find.text(S.current.resumeSubscriptionTitle), findsNothing);
  });

  testWidgets('dismissing the prompt does not retry the connection', (tester) async {
    var attempts = 0;
    when(
      vpnStore.manageConnection(
        location: anyNamed('location'),
        intent: anyNamed('intent'),
        targetIp: anyNamed('targetIp'),
      ),
    ).thenAnswer((_) async {
      attempts++;
      throw const SubscriptionPausedException();
    });

    await pumpHost(tester);
    await tester.tap(find.text(S.current.back));
    await tester.pumpAndSettle();

    verifyNever(subscriptionStore.resumeSubscription());
    expect(attempts, 1, reason: 'no retry without a successful resume');
  });

  testWidgets('a failed resume leaves the prompt open and never retries', (tester) async {
    var attempts = 0;
    when(
      vpnStore.manageConnection(
        location: anyNamed('location'),
        intent: anyNamed('intent'),
        targetIp: anyNamed('targetIp'),
      ),
    ).thenAnswer((_) async {
      attempts++;
      throw const SubscriptionPausedException();
    });
    when(subscriptionStore.resumeSubscription()).thenThrow(Exception('network'));

    await pumpHost(tester);
    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    expect(find.text(S.current.resumeSubscriptionFailed), findsOneWidget);
    expect(find.text(S.current.resumeSubscriptionTitle), findsOneWidget);
    expect(attempts, 1);
  });

  testWidgets('an active subscription connects without a prompt', (tester) async {
    when(
      vpnStore.manageConnection(
        location: anyNamed('location'),
        intent: anyNamed('intent'),
        targetIp: anyNamed('targetIp'),
      ),
    ).thenAnswer((_) async {});

    await pumpHost(tester);

    expect(find.text(S.current.resumeSubscriptionTitle), findsNothing);
    verify(
      vpnStore.manageConnection(
        location: _location,
        intent: anyNamed('intent'),
        targetIp: anyNamed('targetIp'),
      ),
    ).called(1);
  });
}

class _Host extends HookConsumerWidget {
  const _Host();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toggle = useHandleToggleConnection();
    return ElevatedButton(
      onPressed: () async => toggle(location: _location),
      child: const Text('toggle'),
    );
  }
}
