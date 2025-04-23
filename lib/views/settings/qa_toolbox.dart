import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class QAToolbox extends HookConsumerWidget {
  const QAToolbox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final bannerStore = ref.read(bannersStorePOD);
    final locationsStore = ref.read(locationsStorePOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;

        return Column(
          children: [
            SettingItem(
              asset: isDarkTheme ? Assets.resetAppSettingDark : Assets.resetAppSettingLight,
              title: 'Reset hidden banners',
              subtitle: const EasyText('This will reset all hidden banners to be shown again'),
              actionWidget: TextButton.icon(
                label: const EasyText('Reset'),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await bannerStore.resetShown();
                  showSnackbar(
                    'Banners reset successfully',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.resetAppSettingDark : Assets.resetAppSettingLight,
              title: 'Reset recent locations',
              subtitle: const EasyText('This will remove all recent locations'),
              actionWidget: TextButton.icon(
                label: const EasyText('Reset'),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await locationsStore.resetRecentLocations();
                  showSnackbar(
                    'Recent locations reset successfully',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
