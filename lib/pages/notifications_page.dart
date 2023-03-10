import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/platform_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/informational_view.dart';
import 'package:mysterium_vpn/views/notifications/notifications_mobile_view.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => ColoredScaffold(
        body: PlatformTypeLayoutBuilder(
          windows: (BuildContext context) =>
              const InformationalView(translationKey: LocaleKeys.notificationsDesktop),
          android: (BuildContext context) => const NotificationsMobileView(),
          macos: (BuildContext context) =>
              const InformationalView(translationKey: LocaleKeys.notificationsDesktop),
          ios: (BuildContext context) => const NotificationsMobileView(),
        ),
      );
}
