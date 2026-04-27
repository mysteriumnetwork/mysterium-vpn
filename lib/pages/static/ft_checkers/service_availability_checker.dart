import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ServiceAvailabilityChecker extends StatelessWidget {
  const ServiceAvailabilityChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final store = getIt<RemoteConfigStore>();

    return Observer(
      builder: (context) {
        final theme = Theme.of(context);
        if (store.isServiceAvailable) {
          return child;
        } else {
          return ColoredScaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xl2),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: theme.spacing.xl6),
                      const Logo(),
                      const Spacer(),
                      Text(
                        store.isServiceAvailableMessage,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.textMd.regular.copyWith(
                          color: theme.palette.textPrimary,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
