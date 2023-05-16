import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/dialogs/dismiss_page_dialog.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/vpn_config_consent/vpn_config_consent_form.dart';

class VpnConfigConsentView extends HookConsumerWidget {
  const VpnConfigConsentView({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authStore = ref.watch(authStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);

    return Observer(
      builder: (context) => WillPopScope(
        onWillPop: () async {
          if (vpnStore.vpnConfigConsent == false) {
            final shouldPop = await shownDismissPageDialog(context);
            if (shouldPop ?? false) {
              authStore.logout();
            }
            return Future.value(false);
          } else {
            Beamer.of(context).beamBack();
            return Future.value(false);
          }
        },
        child: BaseLayout(
          header: const BaseAppBar(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: const VpnConfigConsentForm(),
          ),
        ),
      ),
    );
  }
}
