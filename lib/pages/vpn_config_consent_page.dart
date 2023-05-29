import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/consent/consent_view.dart';
import 'package:mysterium_vpn/views/consent/vpn_config_consent_form.dart';

class VpnConfigConsentPage extends HookConsumerWidget {
  const VpnConfigConsentPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) =>
      const ColoredScaffold(
        body: ConsentView(
          child: VpnConfigConsentForm(),
        ),
      );
}
