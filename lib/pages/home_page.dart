import 'package:beamer/beamer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/no_internet_connection_dialog.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ReactionBuilder(
        builder: (_) => reaction(
          (_) => ref.read(connectivityStorePOD).connectivityStream.value,
          (result) {
            if (result == ConnectivityResult.none) {
              shownNoInternetConnectionDialog(context);
            }
          },
        ),
        child: ReactionBuilder(
          builder: (context) =>
              reaction((_) => ref.read(subscriptionStorePOD).isSubscribed, (result) {
            debugPrint(result.toString());
            if (result == false) {
              context.beamToNamed(Routes.subscription.toRoute);
            }
          }),
          child: ColoredScaffold(
            body: ScreenTypeLayoutBuilder(
              mobile: (BuildContext context) => const HomeMobileView(),
              tablet: (BuildContext context) => const HomeDesktopView(),
              desktop: (BuildContext context) => const HomeDesktopView(),
            ),
          ),
        ),
      );
}
