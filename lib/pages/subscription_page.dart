import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/platform_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/subscription/subscription_desktop_view.dart';
import 'package:mysterium_vpn/views/subscription/subscription_mobile_view.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) => ColoredScaffold(
        body: PlatformTypeLayoutBuilder(
          windows: (BuildContext context) => const SubscriptionDesktopView(),
          android: (BuildContext context) => const SubscriptionMobileView(),
          macos: (BuildContext context) => const SubscriptionDesktopView(),
          ios: (BuildContext context) => const SubscriptionMobileView(),
        ),
      );
}
