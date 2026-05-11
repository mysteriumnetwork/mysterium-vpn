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
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/pages/static/app_deferred_init.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/ft_checkers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

    useEffect(() {
      authSessionStore.initStore().whenComplete(authStore.initAuth);
      return null;
    }, [authStore, authSessionStore]);

    useReaction(() => authSessionStore.isAuthenticated, (isAuthenticated) async {
      if (isAuthenticated) {
        await authStore.fetchAuthUser();
      }
    });

    useMQTTService();
    useConfigCatUserUpdater();
    useSubscriptionWatcher();

    return ReactionBuilder(
      builder: (_) => reaction((_) => authSessionStore.status, (status) {
        _authenticationReaction(status, routeDelegate, ref);
      }),
      child: LifecycleListener(
        onThemeChanged: themeStore.updateSystemTheme,
        child: Observer(
          builder: (context) => RetakeFocusOnTap(
            child: ShortcutsWidget(
              child: CustomPlatformMenu(
                appName: Env.appName,
                child: BeamerProvider(
                  routerDelegate: routeDelegate,
                  child: Portal(
                    child: MaterialApp.router(
                      title: Env.appName,
                      scaffoldMessengerKey: snackbarKey,
                      theme: themeStore.lightTheme,
                      darkTheme: themeStore.darkTheme,
                      themeMode: themeStore.themeMode,
                      routerDelegate: routeDelegate,
                      routeInformationParser: routeInformationParser,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: localStore.currentLocale,
                      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routeDelegate),
                      builder: (context, child) => ScreenTypeObserver(
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              dragDevices: PointerDeviceKind.values.toSet(),
                              scrollbars: false,
                              overscroll: true,
                              physics: const BouncingScrollPhysics(),
                            ),
                            child: AppDeferredInitWidget(
                              child: FTCheckers(child: NetworkLoggerOverlayView(child: child!)),
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
      ),
    );
  }

  Future<void> _authenticationReaction(
    AuthStatus authStatus,
    BeamerDelegate routeDelegate,
    WidgetRef ref,
  ) async {
    routeDelegate.update();

    if (authStatus != AuthStatus.unauthenticated) {
      return;
    }

    await _disposeStore(ref, vpnStorePOD, dispose: (VpnStore s) => s.disposeStore());
    await _disposeStore(ref, dnsStorePOD, dispose: (DNSStore s) => s.disposeStore());
    _invalidateIfExists(ref, locationsStorePOD);
    _invalidateIfExists(ref, subscriptionStorePOD);
    _invalidateIfExists(ref, recentLocationsStorePOD);

    if (ref.exists(refreshIPStorePOD)) {
      ref.read(refreshIPStorePOD).disposeStore();
      ref.invalidate(refreshIPStorePOD);
    }

    // SmartRefreshStore watches locations/subscription stores so it gets
    // auto-invalidated by the lines above. Nothing else reads it, so without
    // this explicit read the old instance stays disposed and its auth
    // reaction can't refresh locations on the next login.
    ref.read(smartRefreshStorePOD);
  }

  Future<void> _disposeStore<T>(
    WidgetRef ref,
    Provider<T> provider, {
    required Future<void> Function(T store) dispose,
  }) async {
    if (!ref.exists(provider)) {
      return;
    }
    await dispose(ref.read(provider));
    ref.invalidate(provider);
  }

  void _invalidateIfExists(WidgetRef ref, Provider<dynamic> provider) {
    if (ref.exists(provider)) {
      ref.invalidate(provider);
    }
  }
}
