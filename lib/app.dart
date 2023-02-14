import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final routeInformationParser = ref.read(routeInformationParserPOD);
    final authStore = ref.read(authStorePOD);
    final routeDelegate = ref.read(routerDelegatePOD);
    final localStore = ref.read(localeStorePOD);

    return ReactionBuilder(
      builder: (context) {
        return reaction((_) => authStore.authStatus, (result) {
          routeDelegate.update();
        });
      },
      child: Observer(builder: (context) {
        return MaterialApp.router(
          key: UniqueKey(),
          theme: themeStore.currentTheme,
          routerDelegate: routeDelegate,
          routeInformationParser: routeInformationParser,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: localStore.currentLocale,
          backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routeDelegate),
        );
      }),
    );
  }
}
