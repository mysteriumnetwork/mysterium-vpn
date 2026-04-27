import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/common/hooks/home_autorun_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final isLoading = useComputedValue(() => authSessionStore.status == AuthStatus.unknown);
    useEffect(() {
      InAppReviewObserver().monitor();

      return null;
    }, []);

    useHomeAutorun();

    return Theme(
      data: DesignSystemTheme.of(context),
      child: ColoredScaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            ScreenTypeLayoutBuilder(
              mobile: (BuildContext context) => const HomeMobileView(),
              tablet: (BuildContext context) => const HomeDesktopView(),
              desktop: (BuildContext context) => const HomeDesktopView(),
            ),
            if (isLoading) LoadingBarrier(color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
