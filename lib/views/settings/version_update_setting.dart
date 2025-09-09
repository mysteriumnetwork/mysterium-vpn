import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:mysterium_vpn/views/settings/action_button.dart';
import 'package:styled_widget/styled_widget.dart';

class AppVersionUpdateSetting extends ConsumerWidget {
  const AppVersionUpdateSetting({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    return Observer(
      builder: (context) {
        if (!shouldShowAppUpdateBanner(remoteConfigStore)) {
          return const SizedBox.shrink();
        }

        return RawMaterialButton(
          onPressed: () async {
            analyticsStore.logEvent(
              AnalyticsEvent.appVersionSettingClicked,
            );
            await openAppStorePage();
          },
          elevation: 0,
          fillColor: context.c.isDarkMode ? const Color(0xff524e77) : Palette.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Palette.purple, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Palette.purple,
                  child: SvgIcon(
                    asset: Asset.icons.appUpdate,
                    width: 16,
                    height: 16,
                  ),
                ).padding(right: 10),
                Expanded(
                  child: EasyText(
                    LocaleKeys.appUpdateAvailableSetting.tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    maxLines: 2,
                  ),
                ),
                SettingActionButton(
                  action: () async {
                    await openAppStorePage();
                  },
                  backgroundColor: Palette.purple,
                  child: EasyText(
                    LocaleKeys.updateBtn.tr(),
                    color: Palette.white,
                  ),
                ),
              ],
            ),
          ),
        ).paddingDirectional(bottom: 10, horizontal: 20);
      },
    );
  }

  bool shouldShowAppUpdateBanner(
    RemoteConfigStore remoteConfigStore,
  ) {
    final latestStableAppVersion = remoteConfigStore.latestStableAppVersion;
    final currentBuildVersion = Env.buildInfo.buildVersion;

    if (currentBuildVersion.compareTo(latestStableAppVersion) >= 0) {
      return false;
    }
    return true;
  }
}
