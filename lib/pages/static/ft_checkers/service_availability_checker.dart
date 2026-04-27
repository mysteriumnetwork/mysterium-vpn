import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ServiceAvailabilityChecker extends ConsumerWidget {
  const ServiceAvailabilityChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(remoteConfigStorePOD);

    return Theme(
      data: DesignSystemTheme.of(context),
      child: Observer(
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
      ),
    );
  }
}
