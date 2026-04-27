import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;
import 'package:styled_widget/styled_widget.dart';

class EmailMarketingSetting extends HookConsumerWidget {
  const EmailMarketingSetting({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    return Observer(
      builder: (_) {
        final visible =
            userPreferencesStore.marketingConsent != null &&
            authSessionStore.status == AuthStatus.authenticated;

        if (!visible) {
          return const SizedBox.shrink();
        }

        final isLoading =
            userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending ||
            userPreferencesStore.getMarketingConsentFuture?.status == FutureStatus.pending;

        return SettingsCard(
          title: LocaleKeys.emailNotificationsSetting.tr(),
          position: position,
          trailing: isLoading
              ? const LoadingIndicator().padding(all: 8)
              : Switch(
                  value: userPreferencesStore.marketingConsent!,
                  onChanged: (val) async {
                    try {
                      await userPreferencesStore.updateMarketingContact(consent: val);
                      analyticsStore.logEvent(
                        AnalyticsEvent.toggleMarketingConsent,
                        parameters: {'value': val.toString()},
                      );
                    } catch (e) {
                      showSnackbar(LocaleKeys.somethingWentWrong.tr());
                    }
                  },
                ),
        );
      },
    );
  }
}
