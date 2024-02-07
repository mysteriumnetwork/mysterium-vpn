import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/router/route_delegate.dart';
import 'package:mysterium_vpn/components/custom_platform_menu.dart';
import 'package:mysterium_vpn/components/lifecycle_listener.dart';
import 'package:mysterium_vpn/components/retake_fokus.dart';
import 'package:mysterium_vpn/components/shortcuts.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(final BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final routeInformationParser = ref.read(routeInformationParserPOD);
    final authStore = ref.read(authStorePOD);
    final routeDelegate = ref.read(routerDelegatePOD);
    final localStore = ref.read(localeStorePOD);
    final appName = ref.watch(environmentPOD).values.appName;

    return ReactionBuilder(
      builder: (_) => reaction(
        (_) => authStore.authStatus,
        (status) {
          authenticationReaction(status, routeDelegate, authStore, ref);
        },
      ),
      child: Observer(
        builder: (context) => RetakeFocusOnTap(
          child: LifecycleListener(
            onDetached: () => ref.read(vpnStorePOD).disconnectWireguard(),
            onResumed: () {
              checkSubsStatus(authStore, ref.read(subscriptionStorePOD));
            },
            onPaused: () {
              checkSubsStatus(authStore, ref.read(subscriptionStorePOD));
            },
            child: ShortcutsWidget(
              child: CustomPlatformMenu(
                appName: appName,
                child: MaterialApp.router(
                  title: appName,
                  key: UniqueKey(),
                  scaffoldMessengerKey: snackbarKey,
                  theme: themeStore.lightTheme,
                  darkTheme: themeStore.darkTheme,
                  themeMode: themeStore.themeMode,
                  routerDelegate: routeDelegate,
                  routeInformationParser: routeInformationParser,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: localStore.currentLocale,
                  backButtonDispatcher: BeamerBackButtonDispatcher(
                    delegate: routeDelegate,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkSubsStatus(AuthStore authStore, SubscriptionStore subscriptionStore) {
    if (authStore.authStatus != AuthStatus.authenticated) {
      return;
    }
    if (subscriptionStore.isSubscribed == false ||
        (subscriptionStore.subscription?.isExpired ?? false)) {
      subscriptionStore.fetchSubscription();
    }
  }

  Future<void> authenticationReaction(
    AuthStatus authStatus,
    BeamerDelegate routeDelegate,
    AuthStore authStore,
    WidgetRef ref,
  ) async {
    routeDelegate.update();
    if (authStatus == AuthStatus.unauthenticated) {
      if (ref.exists(vpnStorePOD)) {
        await ref.read(vpnStorePOD).disconnectWireguard();
        ref.invalidate(vpnStorePOD);
      }
      if (ref.exists(locationsStorePOD)) {
        ref.invalidate(locationsStorePOD);
      }
      if (ref.exists(subscriptionStorePOD)) {
        ref.invalidate(subscriptionStorePOD);
      }
    }
  }
}
