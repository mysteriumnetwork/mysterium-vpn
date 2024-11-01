import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:open_store/open_store.dart';

/// Checks if the current app version is greater than or equal to the minimum required app version.
/// Works only with PROD flavor.
class MinAppVersionChecker extends HookConsumerWidget {
  const MinAppVersionChecker({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(environmentPOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final canContinue = useState(false);

    return Observer(
      builder: (context) {
        final currentBuildVersion = env.buildInfo.buildVersion;
        final minAppBuildNumber = remoteConfigStore.minBuildNumber;
        if (currentBuildVersion.compareTo(minAppBuildNumber) >= 0 || canContinue.value) {
          return child;
        } else {
          return Scaffold(
            backgroundColor: Palette.darkBlue,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 64),
                    const SvgIcon(
                      asset: Assets.splashLogo,
                    ),
                    const Spacer(),
                    EasyText(
                      LocaleKeys.featureToggleMinVersionNotSatisfied.tr(),
                      textAlign: TextAlign.center,
                      color: Palette.white,
                    ),
                    const SizedBox(height: 40),
                    EasyButton(
                      onPressed: () async {
                        try {
                          OpenStore.instance.open(
                            appStoreId: '6446624307',
                            appStoreIdMacOS: '6446624307',
                            androidAppBundleId: 'com.mysteriumvpn.android',
                            windowsProductId: '9NGWJCZSB5MK',
                          );
                        } catch (e) {
                          // Unable to open the store, unblock the user
                          canContinue.value = true;
                        }
                      },
                      text: LocaleKeys.buttonUpdateApp.tr(),
                    ),
                    const Spacer(),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
