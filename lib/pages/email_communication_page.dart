import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/platform_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/email_communications/email_communications_mobile_view.dart';
import 'package:mysterium_vpn/views/informational_view.dart';

class EmailCommunicationPage extends StatelessWidget {
  const EmailCommunicationPage({super.key});

  @override
  Widget build(BuildContext context) => ColoredScaffold(
        body: PlatformTypeLayoutBuilder(
          windows: (BuildContext context) =>
              const InformationalView(translationKey: LocaleKeys.emailCommunicationsDesktop),
          android: (BuildContext context) => const EmailCommunicationsMobileView(),
          macos: (BuildContext context) =>
              const InformationalView(translationKey: LocaleKeys.emailCommunicationsDesktop),
          ios: (BuildContext context) => const EmailCommunicationsMobileView(),
        ),
      );
}
