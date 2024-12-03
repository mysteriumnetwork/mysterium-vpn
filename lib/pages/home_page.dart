import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/info_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/in_app_review/in_app_review.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';
import 'package:wireguard_dart/connection_status.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);

    useEffect(
      () {
        InAppReviewObserver().monitor();
        return null;
      },
      [],
    );

    useAutorun(() {
      if ((vpnStore.vpnConfig?.limitExceeded ?? false) &&
          vpnStore.connectionStatus == ConnectionStatus.connected) {
        shownInfoDialog(
          context,
          LocaleKeys.connectionLimitExceededTitle.tr(),
          messages: [
            LocaleKeys.connectionLimitExceededDesc.tr(),
          ],
          isDismissible: true,
          confirmText: LocaleKeys.iUnderstandBtn.tr(),
        );
      }
    });

    useReaction(
      () => vpnStore.vpnConfigConsent,
      (vpnConfigConsent) {
        if (vpnConfigConsent == null) {
          return;
        }
        if (!vpnConfigConsent) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Beamer.of(context).beamToNamed(Routes.privacyPolicy.path);
          });
        }
      },
      fireImmediately: true,
    );

    return ColoredScaffold(
      body: ScreenTypeLayoutBuilder(
        mobile: (BuildContext context) => const HomeMobileView(),
        tablet: (BuildContext context) => const HomeDesktopView(),
        desktop: (BuildContext context) => const HomeDesktopView(),
      ),
    );
  }
}
