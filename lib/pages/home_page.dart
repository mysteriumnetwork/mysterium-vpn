import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final environment = ref.watch(environmentPOD);

    useOnAppLifecycleStateChange(
      (previous, current) {
        debugPrint('App Lifecycle: $previous -> $current');
        // TODO(Kristijan): ADD THIS BACK WHEN WE GO LIVE
        if (isDekstop() &&
            subscriptionStore.isSubscribed == false &&
            previous == AppLifecycleState.inactive &&
            current == AppLifecycleState.resumed) {
          subscriptionStore.fetchSubscription();
        }
        if (current == AppLifecycleState.detached) {
          vpnStore.disconnect();
        }
        return null;
      },
    );

    return ReactionBuilder(
      builder: (_) => reaction((_) => subscriptionStore.subscriptionFuture?.status, (result) {
        debugPrint(result.toString());
        if (result == FutureStatus.fulfilled &&
            subscriptionStore.subscription?.active == false &&
            (vpnStore.vpnConfigConsent ?? false)) {
          handleOnBillingPage(
            billingPage: environment.values.billingPage,
            context: context,
            gateway: subscriptionStore.subscription?.gateway,
            subscriptionActive: subscriptionStore.subscription?.active ?? false,
          );
        }
        if (result == FutureStatus.rejected) {
          shownRetryDialog(
            onRetry: () async => subscriptionStore.fetchSubscription(),
            context: context,
            asset: Assets.subscription,
            title: LocaleKeys.fetchSubsFailed.tr(),
            subtitle: LocaleKeys.fetchSubsFailedDesc.tr(),
            onDismiss: authStore.logout,
            dismissText: LocaleKeys.logout.tr(),
            isDismissible: false,
          );
        }
      }),
      child: ReactionBuilder(
        builder: (_) => when(
          (_) => vpnStore.vpnConfigConsent == false,
          () {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => Beamer.of(context).beamToNamed(Routes.vpnPrivacyConsent.toRoute),
            );
          },
        ),
        child: ColoredScaffold(
          body: ScreenTypeLayoutBuilder(
            mobile: (BuildContext context) => const HomeMobileView(),
            tablet: (BuildContext context) => const HomeDesktopView(),
            desktop: (BuildContext context) => const HomeDesktopView(),
          ),
        ),
      ),
    );
  }
}
