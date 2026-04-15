import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';

class ServiceAvailabilityChecker extends StatelessWidget {
  const ServiceAvailabilityChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final store = getIt<RemoteConfigStore>();

    return Observer(
      builder: (context) {
        if (store.isServiceAvailable) {
          return child;
        } else {
          return Scaffold(
            backgroundColor: Palette.darkBlue,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(asset: Asset.logo.splashLogo, width: 150),
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
