import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/platform_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/informational_view.dart';
import 'package:mysterium_vpn/views/subscription/subscription_mobile_scaffold.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) => ColoredScaffold(
        body: PlatformTypeLayoutBuilder(
          windows: (BuildContext context) =>
              const InformationalView(translationKey: LocaleKeys.subscriptionDesktop),
          android: (BuildContext context) => const SubscriptionMobileScaffold(),
          macos: (BuildContext context) => const SubscriptionMobileScaffold(),
          ios: (BuildContext context) => const SubscriptionMobileScaffold(),
        ),
      );
}
