import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AppVersionUpdateBanner extends HookConsumerWidget {
  const AppVersionUpdateBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final bannersStore = ref.watch(bannersStorePOD);

    Future<void> handlePressed() async {
      analyticsStore.logBannerClick(BannerType.appUpdateAvailable);
      await openAppStorePage();
    }

    void handleDismiss() {
      analyticsStore.logBannerClose(BannerType.appUpdateAvailable);
      bannersStore.setShown(BannerType.appUpdateAvailable);
    }

    return AlertModal(
      type: AlertModalType.info,
      title: LocaleKeys.appUpdateAvailableTitle.tr(),
      supportingText: LocaleKeys.appUpdateAvailableDesc.tr(),
      onClose: handleDismiss,
      primaryButton: ButtonPrimary(
        size: ButtonSize.small,
        onPressed: handlePressed,
        child: Text(LocaleKeys.updateBtn.tr()),
      ),
    );
  }
}
