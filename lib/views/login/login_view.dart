import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/login/login_form.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SignInView extends HookConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.read(authStorePOD);
    final palette = Theme.of(context).palette;

    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              UnauthenticatedHeader(backLabel: S.current.homeLbl),
              const Expanded(child: SignInForm()),
            ],
          ),
          if (authStore.authenticateFeature?.status == FutureStatus.pending)
            LoadingBarrier(color: palette.bgPopover),
        ],
      ),
    );
  }
}
