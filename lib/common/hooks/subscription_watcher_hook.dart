import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';

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
  @override
  void initHook() {
    super.initHook();
    final state = WidgetsBinding.instance.lifecycleState;
    if (state == AppLifecycleState.resumed) {
      _onResumed();
    }

    WidgetsBinding.instance.addObserver(this);
  }

  void _onResumed() {
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
      _onResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
