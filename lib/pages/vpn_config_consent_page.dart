import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/vpn_config_consent/vpn_config_consent_view.dart';

class VpnConfigConsentPage extends HookConsumerWidget {
  const VpnConfigConsentPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) =>
      ColoredScaffold(
        body: ScreenTypeLayoutBuilder(
          mobile: (BuildContext context) => const VpnConfigConsentView(),
          tablet: (BuildContext context) => const VpnConfigConsentView(),
          desktop: (BuildContext context) => const VpnConfigConsentView(),
        ),
      );
}
