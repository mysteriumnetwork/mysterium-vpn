import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final authStore = ref.watch(authStorePOD);
    return ReactionBuilder(
      builder: (context) => reaction((_) => subscriptionStore.subscriptionFuture?.status, (result) {
        debugPrint(result.toString());
        if (result == FutureStatus.fulfilled && subscriptionStore.subscription?.active == false) {
          context.beamToNamed(Routes.subscription.toRoute);
        }
        if (result == FutureStatus.rejected) {
          shownRetryDialog(
            onRetry: () async => subscriptionStore.fetchSubscription(),
            context: context,
            asset: Assets.subscription,
            title: LocaleKeys.fetchSubsFailed.tr(),
            subtitle: LocaleKeys.fetchSubsFailedDesc.tr(),
            onDismiss: authStore.logout,
          );
        }
      }),
      child: ColoredScaffold(
        body: ScreenTypeLayoutBuilder(
          mobile: (BuildContext context) => const HomeMobileView(),
          tablet: (BuildContext context) => const HomeDesktopView(),
          desktop: (BuildContext context) => const HomeDesktopView(),
        ),
      ),
    );
  }
}
