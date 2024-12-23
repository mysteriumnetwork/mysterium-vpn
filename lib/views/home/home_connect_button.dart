import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/connect_button_animated.dart';

class HomeConnectButton extends HookConsumerWidget {
  const HomeConnectButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleToggleConnection = useHandleToggleConnection();

    Future<void> handleConnect() async {
      await handleToggleConnection(
        selectEvent: (connected) =>
            connected ? AnalyticsEvent.disconnectMain : AnalyticsEvent.connectMain,
      );
    }

    return ConnectButtonAnimated(onPressed: handleConnect);
  }
}
