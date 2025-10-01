import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/info_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/in_app_review/in_app_review.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:mysterium_vpn/stores/vpn/i_vpn.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);
    final isLoading = useComputedValue(() => authSessionStore.status == AuthStatus.unknown);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final screenType = useScreenType();
    useEffect(
      () {
        InAppReviewObserver().monitor();

        return null;
      },
      [],
    );

    useAutorun(() {
      connectionLimitAutorun(vpnStore, context);
    });
    useAutorun(() {
      marketingConsentAutorun(userPreferencesStore, context, screenType);
    });

    return ColoredScaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ScreenTypeLayoutBuilder(
            mobile: (BuildContext context) => const HomeMobileView(),
            tablet: (BuildContext context) => const HomeDesktopView(),
            desktop: (BuildContext context) => const HomeDesktopView(),
          ),
          if (isLoading)
            Positioned.fill(
              child: LoadingBarrier(color: Theme.of(context).primaryColor),
            ),
        ],
      ),
    );
  }

  void connectionLimitAutorun(IVpnStore vpnStore, BuildContext context) {
    if ((vpnStore.limitExceeded) && vpnStore.vpnStatus == VpnConnectionStatus.connected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        shownInfoDialog(
          context,
          LocaleKeys.connectionLimitExceededTitle.tr(),
          messages: [
            LocaleKeys.connectionLimitExceededDesc.tr(),
          ],
          isDismissible: true,
          confirmText: LocaleKeys.iUnderstandBtn.tr(),
        );
      });
    }
  }

  void marketingConsentAutorun(
    UserPreferencesStore userPreferencesStore,
    BuildContext context,
    ScreenType screenType,
  ) {
    if (userPreferencesStore.canShowMarketingConsentDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMarketingConsentDialog(context, desktopSize: screenType == ScreenType.desktop);
      });
    }
  }
}
