import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/config_cat_user_updater_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/mqtt_service.dart';
import 'package:mysterium_vpn/common/hooks/subscription_watcher_hook.dart';
import 'package:mysterium_vpn/common/router/route_delegate.dart';
import 'package:mysterium_vpn/components/custom_platform_menu.dart';
import 'package:mysterium_vpn/components/lifecycle_listener.dart';
import 'package:mysterium_vpn/components/network_logger_overlay.dart';
import 'package:mysterium_vpn/components/retake_fokus.dart';
import 'package:mysterium_vpn/components/shortcuts.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/ft_checkers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

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
    const appName = Env.appName;
    ref.watch(realIPInfoStorePOD);

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

    useMQTTService();
    useConfigCatUserUpdater();
    useSubscriptionWatcher();

    return ReactionBuilder(
      builder: (_) => reaction(
        (_) => authSessionStore.status,
        (status) {
          authenticationReaction(status, routeDelegate, ref);
        },
      ),
      child: LifecycleListener(
        onThemeChanged: themeStore.updateSystemTheme,
        child: Observer(
          builder: (context) => RetakeFocusOnTap(
            child: ShortcutsWidget(
              child: CustomPlatformMenu(
                appName: appName,
                child: BeamerProvider(
                  routerDelegate: routeDelegate,
                  child: Portal(
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
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaler: TextScaler.noScaling,
                        ),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: PointerDeviceKind.values.toSet(),
                            scrollbars: false,
                            overscroll: true,
                            physics: const BouncingScrollPhysics(),
                          ),
                          child: FTCheckers(
                            child: NetworkLoggerOverlayView(child: child!),
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
      ),
    );
  }

  Future<void> authenticationReaction(
    AuthStatus authStatus,
    BeamerDelegate routeDelegate,
    WidgetRef ref,
  ) async {
    routeDelegate.update();
    if (authStatus == AuthStatus.unauthenticated) {
      if (ref.exists(vpnStorePOD)) {
        await ref.read(vpnStorePOD).disposeStore();
        ref.invalidate(vpnStorePOD);
      }
      if (ref.exists(dnsStorePOD)) {
        await ref.read(dnsStorePOD).disposeStore();
        ref.invalidate(dnsStorePOD);
      }
      if (ref.exists(locationsStorePOD)) {
        ref.invalidate(locationsStorePOD);
      }
      if (ref.exists(subscriptionStorePOD)) {
        ref.invalidate(subscriptionStorePOD);
      }
      if (ref.exists(refreshIPStorePOD)) {
        ref.read(refreshIPStorePOD).disposeStore();
        ref.invalidate(refreshIPStorePOD);
      }
      if (ref.exists(recentLocationsStorePOD)) {
        ref.invalidate(recentLocationsStorePOD);
      }
    }
  }
}
