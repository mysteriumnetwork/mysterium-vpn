import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/switch_item.dart';
import 'package:styled_widget/styled_widget.dart';

class EmailMarketingSetting extends HookConsumerWidget {
  const EmailMarketingSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    return Observer(
      builder: (context) {
        final shouldShowLoadingIndicator = _shouldShowLoadingIndicator(userPreferencesStore);
        final visible = userPreferencesStore.marketingConsent != null &&
            authSessionStore.status == AuthStatus.authenticated;
        return Visibility(
          visible: visible,
          child: SwitchItem(
            asset: Asset.icons.emailNotification(context),
            title: LocaleKeys.emailNotificationsSetting.tr(),
            subtitle: LocaleKeys.emailNotificationsSettingDesc.tr(),
            actionWidget: Observer(
              builder: (context) => shouldShowLoadingIndicator
                  ? const LoadingIndicator().padding(all: 8)
                  : Switch(
                      value: userPreferencesStore.marketingConsent!,
                      onChanged: (val) async {
                        try {
                          await userPreferencesStore.updateMarketingContact(
                            consent: val,
                          );
                          analyticsStore.logEvent(
                            AnalyticsEvent.toggleMarketingConsent,
                            parameters: {'value': val.toString()},
                          );
                        } catch (e) {
                          showSnackbar(
                            LocaleKeys.somethingWentWrong.tr(),
                          );
                        }
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  bool _shouldShowLoadingIndicator(
    UserPreferencesStore userPreferencesStore,
  ) =>
      userPreferencesStore.updateMarketingConsentFuture.status == FutureStatus.pending ||
      userPreferencesStore.getMarketingConsentFuture?.status == FutureStatus.pending;
}
