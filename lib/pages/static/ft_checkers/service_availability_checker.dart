import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ServiceAvailabilityChecker extends ConsumerWidget {
  const ServiceAvailabilityChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(remoteConfigStorePOD);

    return Observer(
      builder: (context) {
        if (store.isServiceAvailable) {
          return child;
        } else {
          return Scaffold(
            backgroundColor: Palette.darkBlue,
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    asset: Asset.logo.splashLogo,
                    width: 150,
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: Center(
                      child: EasyText(
                        store.isServiceAvailableMessage,
                        textAlign: TextAlign.center,
                        color: Palette.white,
                        maxLines: 4,
                      ),
                    ),
                  ),
                  const BottomSpacer(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
