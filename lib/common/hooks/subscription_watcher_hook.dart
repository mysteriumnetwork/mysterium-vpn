import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void useSubscriptionWatcher() {
  use(const _SubscriptionWatcherHook());
}

class _SubscriptionWatcherHook extends Hook<void> {
  const _SubscriptionWatcherHook();

  @override
  _SubscriptionWatcherHookState createState() => _SubscriptionWatcherHookState();
}

class _SubscriptionWatcherHookState extends HookState<void, _SubscriptionWatcherHook>
    with WidgetsBindingObserver {
  late ReactionDisposer disposer;

  @override
  void initHook() {
    super.initHook();
    final state = WidgetsBinding.instance.lifecycleState;
    final ref = ProviderScope.containerOf(context, listen: false);
    final authSessionStore = ref.read(authSessionStorePOD);

    if (state == AppLifecycleState.resumed) {
      onResumed();
    }

    disposer = reaction(
      (_) => authSessionStore.status,
      (_) => onResumed(),
      fireImmediately: false,
    );

    WidgetsBinding.instance.addObserver(this);
  }

  void onResumed() {
    final ref = ProviderScope.containerOf(context, listen: false);
    final authSessionStore = ref.read(authSessionStorePOD);
    if (authSessionStore.status != AuthStatus.authenticated) {
      return;
    }

    final subscriptionStore = ref.read(subscriptionStorePOD);
    Future.microtask(subscriptionStore.refreshSubscription);
  }

  @override
  void build(BuildContext context) {}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }

  @override
  void dispose() {
    disposer.call();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
