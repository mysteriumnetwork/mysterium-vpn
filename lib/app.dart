import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeStore = ref.read(localeStorePOD);
    final themeStore = ref.read(themeStorePOD);
    final routeInformationParser = ref.read(routeInformationParserPOD);
    final authStore = ref.read(authStorePOD);
    final routeDelegate = ref.read(routerDelegatePOD);

    return Observer(builder: (context) {
      return ReactionBuilder(
        builder: (context) {
          return reaction((_) => authStore.authStatus, (result) {
            routeDelegate.update();
          });
        },
        child: MaterialApp.router(
          theme: themeStore.currentTheme,
          routerDelegate: routeDelegate,
          routeInformationParser: routeInformationParser,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeStore.currentLocale,
        ),
      );
    });
  }
}
