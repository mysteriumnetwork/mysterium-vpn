import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/hooks/home_autorun_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_desktop_scaffold.dart';
import 'package:mysterium_vpn/views/home/home_mobile_scaffold.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/home/residential_education_trigger.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final isLoading = useComputedValue(() => authSessionStore.status == AuthStatus.unknown);

    useHomeAutorun();

    return ColoredScaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Mounted once for the whole home shell (not per-scaffold) so the
          // education trigger survives mobile↔desktop resizes.
          ResidentialEducationTrigger(
            connectedCardKey: ref.watch(homeStateProvider).connectedCardKey,
            child: ScreenTypeLayoutBuilder(
              mobile: (BuildContext context) => const HomeMobileScaffold(),
              tablet: (BuildContext context) => const HomeDesktopScaffold(),
              desktop: (BuildContext context) => const HomeDesktopScaffold(),
            ),
          ),
          if (isLoading) LoadingBarrier(color: Theme.of(context).palette.bgPopover),
        ],
      ),
    );
  }
}
