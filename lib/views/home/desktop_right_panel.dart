import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeDesktopRightPanel extends HookConsumerWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    return LayoutBuilder(
      builder: (context, constraints) => DecoratedBox(
        decoration: BoxDecoration(color: Theme.of(context).palette.bgPrimary),
        child: Stack(
          children: [
            const HomeConnectionView(),
            Positioned(
              bottom: 48,
              left: 24,
              right: 24,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth < 432 ? constraints.maxWidth : 432,
                  ),
                  child: Observer(
                    builder: (context) => locationsStore.hasNoServers
                        ? const SizedBox.shrink()
                        : const ConnectionTile(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
