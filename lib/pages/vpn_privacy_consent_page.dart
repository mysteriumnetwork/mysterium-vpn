import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/dismiss_page_dialog.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/consent/consent_view.dart';
import 'package:mysterium_vpn/views/consent/vpn_privacy_consent_form.dart';

class VpnPrivacyConsentPage extends HookConsumerWidget {
  const VpnPrivacyConsentPage({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final localDb = ref.watch(localDBPOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final authStore = ref.watch(authStorePOD);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (localDb.getVpnPrivacyPolicyConsent() == false) {
          final shouldPop = await shownDismissPageDialog(context);
          if (shouldPop ?? false) {
            authStore.logout();
          }
        } else {
          analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
          Beamer.of(context).beamBack();
        }
      },
      child: const ColoredScaffold(
        body: ConsentView(
          child: VpnPrivacyConsentForm(),
        ),
      ),
    );
  }
}
