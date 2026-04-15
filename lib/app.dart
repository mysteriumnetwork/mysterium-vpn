import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/locale/locale_store.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/recent_locations_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/config_cat_user_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/texts_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/dns_store.dart';
import 'package:mysterium_vpn/features/vpn/store/refresh_ip_store.dart';
import 'package:mysterium_vpn/features/vpn/store/smart_refresh_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/pages/static/app_deferred_init.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/ft_checkers.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/shared/components/custom_platform_menu.dart';
import 'package:mysterium_vpn/shared/components/lifecycle_listener.dart';
import 'package:mysterium_vpn/shared/components/network_logger_overlay.dart';
import 'package:mysterium_vpn/shared/components/retake_fokus.dart';
import 'package:mysterium_vpn/shared/components/shortcuts.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Stores resolved from GetIt (singletons — safe as State fields)
  final _themeStore = getIt<ThemeStore>();
  final _authStore = getIt<AuthStore>();
  final _authSessionStore = getIt<AuthSessionStore>();
  final _routeDelegate = getIt<BeamerDelegate>();
  final _routeInformationParser = getIt<BeamerParser>();
  final _localeStore = getIt<LocaleStore>();
  final _mqtt = getIt<MQTTService>();
  final _remoteConfigStore = getIt<RemoteConfigStore>();
  final _abTestingStore = getIt<ABTestingStore>();
  final _textsStore = getIt<TextsStore>();
  final _configCatUserStore = getIt<ConfigCatUserStore>();
  final _subscriptionStore = getIt<SubscriptionStore>();

  late final ReactionDisposer _authStatusDisposer;
  late final ReactionDisposer _authSessionDisposer;
  late final ReactionDisposer _mqttDisposer;
  late final ReactionDisposer _configCatUserDisposer;
  late final ReactionDisposer _subscriptionWatcherDisposer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // Initialise auth session then auth (replaces useEffect)
    _authSessionStore.initStore().whenComplete(_authStore.initAuth);

    // Fetch user data when session becomes authenticated
    _authSessionDisposer = reaction(
      (_) => _authSessionStore.isAuthenticated,
      (bool isAuthenticated) async {
        if (isAuthenticated) await _authStore.fetchAuthUser();
      },
    );

    // Routing + store cleanup on auth status change
    _authStatusDisposer = reaction(
      (_) => _authSessionStore.status,
      _authenticationReaction,
    );

    // MQTT: start and subscribe to config-cat changes (replaces useMQTTService)
    _mqttDisposer = reaction(
      (_) => _authSessionStore.isAuthenticated,
      (bool authenticated) {
        if (authenticated) {
          _mqtt.start().then((_) {
            _mqtt.subscribe('config-cat/changed').listen((_) {
              _remoteConfigStore.refresh();
            });
          });
        } else {
          _mqtt.stop();
        }
      },
      fireImmediately: true,
    );

    // Update ConfigCat user on user change (replaces useConfigCatUserUpdater)
    _configCatUserDisposer = reaction(
      (_) => _configCatUserStore.future.value,
      (user) async {
        if (user == null) return;
        await _abTestingStore.setUser(user);
        await _remoteConfigStore.setUser(user);
        await _textsStore.setUser(user);
      },
      fireImmediately: true,
    );

    // Refresh subscription on app resume / auth change (replaces useSubscriptionWatcher)
    _subscriptionWatcherDisposer = reaction(
      (_) => _authSessionStore.status,
      (_) => _onResumed(),
      fireImmediately: false,
    );

    // Fire once on startup if already resumed
    final initialState = WidgetsBinding.instance.lifecycleState;
    if (initialState == AppLifecycleState.resumed) {
      _onResumed();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResumed();
    }
  }

  void _onResumed() {
    if (!_authSessionStore.isAuthenticated) return;
    Future.microtask(() => _subscriptionStore.refreshSubscription(force: true));
  }

  @override
  void dispose() {
    _authStatusDisposer();
    _authSessionDisposer();
    _mqttDisposer();
    _configCatUserDisposer();
    _subscriptionWatcherDisposer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _authenticationReaction(AuthStatus authStatus) {
    _routeDelegate.update();
    if (authStatus != AuthStatus.unauthenticated) return;

    // Reset stores on logout — disposeStore() resets state; singletons stay in GetIt.
    getIt<VpnStore>().disposeStore();
    getIt<DNSStore>().disposeStore();
    getIt<LocationsStore>().dispose();
    getIt<SubscriptionStore>().dispose();
    getIt<RecentLocationsStore>().dispose();
    getIt<RefreshIPStore>().disposeStore();
    getIt<SmartRefreshStore>().dispose();
    getIt<PushNotificationsStore>().dispose();
  }

  @override
  Widget build(BuildContext context) => LifecycleListener(
      onThemeChanged: _themeStore.updateSystemTheme,
      child: Observer(
        builder: (context) => RetakeFocusOnTap(
          child: ShortcutsWidget(
            child: CustomPlatformMenu(
              appName: Env.appName,
              child: BeamerProvider(
                routerDelegate: _routeDelegate,
                child: Portal(
                  child: MaterialApp.router(
                    title: Env.appName,
                    scaffoldMessengerKey: snackbarKey,
                    theme: _themeStore.lightTheme,
                    darkTheme: _themeStore.darkTheme,
                    themeMode: _themeStore.themeMode,
                    routerDelegate: _routeDelegate,
                    routeInformationParser: _routeInformationParser,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: _localeStore.currentLocale,
                    backButtonDispatcher:
                        BeamerBackButtonDispatcher(delegate: _routeDelegate),
                    builder: (context, child) => ScreenTypeObserver(
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: TextScaler.noScaling),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: PointerDeviceKind.values.toSet(),
                            scrollbars: false,
                            overscroll: true,
                            physics: const BouncingScrollPhysics(),
                          ),
                          child: AppDeferredInitWidget(
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
      ),
    );
}
