import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/router/route_delegate.dart';
import 'package:mysterium_vpn/components/custom_platform_menu.dart';
import 'package:mysterium_vpn/components/lifecycle_listener.dart';
import 'package:mysterium_vpn/components/network_logger_overlay.dart';
import 'package:mysterium_vpn/components/retake_fokus.dart';
import 'package:mysterium_vpn/components/shortcuts.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/ft_checkers.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final routeInformationParser = ref.read(routeInformationParserPOD);
    final authStore = ref.read(authStorePOD);
    final authSessionStore = ref.read(authSessionStorePOD);
    final routeDelegate = ref.read(routerDelegatePOD);
    final localStore = ref.read(localeStorePOD);
    final env = ref.read(environmentPOD);
    final appName = env.values.appName;
    final flavor = env.flavor;
    final mqtt = ref.read(vpnApiMQTTPOD);

    useEffect(
      () {
        authSessionStore.initStore().whenComplete(authStore.initAuth);
        return null;
      },
      [authStore, authSessionStore],
    );
    useReaction(() => authSessionStore.status == AuthStatus.authenticated, (_) async {
      if (authSessionStore.status == AuthStatus.authenticated) {
        await authStore.fetchAuthUser();
      }
    });
    useEffect(
      () {
        mqtt.start();
        return mqtt.stop;
      },
      [mqtt],
    );

    return ReactionBuilder(
      builder: (_) => reaction(
        (_) => authSessionStore.status,
        (status) {
          authenticationReaction(status, routeDelegate, ref);
        },
      ),
      child: LifecycleListener(
        onResumed: () {
          checkSubsStatus(authSessionStore.status, ref.read(subscriptionStorePOD));
        },
        onThemeChanged: themeStore.updateSystemTheme,
        child: Observer(
          builder: (context) => RetakeFocusOnTap(
            child: ShortcutsWidget(
              child: CustomPlatformMenu(
                appName: appName,
                child: BeamerProvider(
                  routerDelegate: routeDelegate,
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
                    builder: (context, child) => ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: PointerDeviceKind.values.toSet(),
                        scrollbars: false,
                        overscroll: true,
                        physics: const BouncingScrollPhysics(),
                      ),
                      child: FTCheckers(
                        child: NetworkLoggerOverlayView(
                          flavor: flavor,
                          child: child!,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkSubsStatus(
    AuthStatus authStatus,
    SubscriptionStore subscriptionStore,
  ) {
    if (authStatus != AuthStatus.authenticated) {
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
    WidgetRef ref,
  ) async {
    routeDelegate.update();
    if (authStatus == AuthStatus.unauthenticated) {
      if (ref.exists(vpnStorePOD)) {
        ref.read(vpnStorePOD).disconnectWireguard().whenComplete(() {
          ref.invalidate(vpnStorePOD);
        });
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
