import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/dialogs/dismiss_page_dialog.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ConsentView extends HookConsumerWidget {
  const ConsentView({
    required this.child,
    super.key,
  });
  final Widget child;
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authStore = ref.watch(authStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (vpnStore.vpnConfigConsent == false) {
          final shouldPop = await shownDismissPageDialog(context);
          if (shouldPop ?? false) {
            authStore.logout();
          }
        } else {
          analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
          Future.microtask(Beamer.of(context).beamBack);
        }
      },
      child: BaseLayout(
        header: const BaseAppBar(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
