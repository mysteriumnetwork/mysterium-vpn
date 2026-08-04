import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/vpn/vpn_guard.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'vpn_guard_test.mocks.dart';

class _TestVpnGuard extends VpnGuard {
  _TestVpnGuard({required super.subscriptionStore, required super.authSessionStore});
}

@GenerateNiceMocks([MockSpec<SubscriptionStore>(), MockSpec<AuthSessionStore>()])
void main() {
  late MockSubscriptionStore subscription;
  late MockAuthSessionStore session;

  setUp(() {
    subscription = MockSubscriptionStore();
    session = MockAuthSessionStore();
    when(session.accessTokenFuture).thenAnswer((_) => ObservableFuture.value('token'));
    when(session.isAuthenticated).thenReturn(true);
  });

  _TestVpnGuard newGuard() =>
      _TestVpnGuard(subscriptionStore: subscription, authSessionStore: session);

  test('throws AuthenticationRequiredException when not authenticated', () async {
    when(session.isAuthenticated).thenReturn(false);

    await expectLater(newGuard().checkVpnGuards(), throwsA(isA<AuthenticationRequiredException>()));
  });

  test('returns silently while subscription is still pending', () async {
    final completer = Completer<Subscription>();
    when(
      subscription.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture<Subscription>(completer.future));

    await newGuard().checkVpnGuards();
    completer.complete(Subscription.empty());
  });

  test('throws SubscriptionRequiredException when subscription is inactive', () async {
    when(
      subscription.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    await expectLater(newGuard().checkVpnGuards(), throwsA(isA<SubscriptionRequiredException>()));
  });

  test('passes when authenticated and subscription is active', () async {
    when(subscription.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(Subscription(active: true, expired: false, recurring: true)),
    );

    await newGuard().checkVpnGuards();
  });

  test('throws SubscriptionPausedException when subscription is active and paused', () async {
    when(subscription.subscriptionFuture).thenAnswer(
      (_) => ObservableFuture.value(
        Subscription(active: true, expired: false, recurring: true, paused: true),
      ),
    );

    await expectLater(newGuard().checkVpnGuards(), throwsA(isA<SubscriptionPausedException>()));
    verifyNever(subscription.refreshSubscription());
  });

  test('refreshes subscription on non-SubscriptionRequiredException errors', () async {
    when(
      subscription.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.error(Exception('network')));
    when(subscription.refreshSubscription()).thenAnswer((_) async => Subscription.empty());

    await expectLater(newGuard().checkVpnGuards(), throwsA(isA<Exception>()));
    verify(subscription.refreshSubscription()).called(1);
  });

  test('does not refresh on SubscriptionRequiredException', () async {
    when(
      subscription.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture.value(Subscription.empty()));

    await expectLater(newGuard().checkVpnGuards(), throwsA(isA<SubscriptionRequiredException>()));
    verifyNever(subscription.refreshSubscription());
  });
}
