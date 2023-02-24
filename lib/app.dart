import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/retake_fokus.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

/// My app
class MyApp extends HookConsumerWidget {
  ///asd
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final routeInformationParser = ref.read(routeInformationParserPOD);
    final authStore = ref.read(authStorePOD);
    final routeDelegate = ref.read(routerDelegatePOD);
    final localStore = ref.read(localeStorePOD);

    return ReactionBuilder(
      builder: (context) => reaction((_) => authStore.authStatus, (result) {
        routeDelegate.update();
      }),
      child: Observer(
        builder: (context) => RetakeFocusOnTap(
          child: MaterialApp.router(
            title: 'Mysterium VPN',
            key: UniqueKey(),
            theme: themeStore.lightTheme,
            darkTheme: themeStore.darkTheme,
            themeMode: themeStore.themeMode,
            routerDelegate: routeDelegate,
            routeInformationParser: routeInformationParser,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: localStore.currentLocale,
            backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routeDelegate),
          ),
        ),
      ),
    );
  }
}
