import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/retake_fokus.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';

/// My app
class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(final BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final routeInformationParser = ref.read(routeInformationParserPOD);
    final authStore = ref.read(authStorePOD);
    final routeDelegate = ref.read(routerDelegatePOD);
    final localStore = ref.read(localeStorePOD);
    final connectivityStore = ref.read(connectivityStorePOD);
    final appLifecycleState = useAppLifecycleState();

    useEffect(
      () {
        debugPrint(appLifecycleState?.name);
        if (appLifecycleState == AppLifecycleState.resumed) {
          connectivityStore.isInitState = true;
        }
        return null;
      },
      [appLifecycleState],
    );
    return ReactionBuilder(
      builder: (_) => reaction(
        (_) => authStore.authStatus,
        (status) {
          authenticationReaction(status, routeDelegate, authStore, ref);
        },
      ),
      child: Observer(
        builder: (context) => RetakeFocusOnTap(
          child: MaterialApp.router(
            title: 'Mysterium VPN',
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
    );
  }

  void authenticationReaction(
    AuthStatus status,
    BeamerDelegate routeDelegate,
    AuthStore authStore,
    WidgetRef ref,
  ) {
    routeDelegate.update();
    if (status == AuthStatus.unauthenticated) {
      ref
        ..invalidate(subscriptionStorePOD)
        ..invalidate(vpnStorePOD)
        ..invalidate(locationsStorePOD)
        ..invalidate(vpnStorePOD);
    }
  }
}
