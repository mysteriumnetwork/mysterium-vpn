import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

/// Checks if the current app version is greater than or equal to the minimum required app version.
/// Works only with PROD flavor.
class MinAppVersionChecker extends HookConsumerWidget {
  const MinAppVersionChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final canContinue = useState(false);

    return Observer(
      builder: (context) {
        final currentBuildVersion = Env.buildInfo.buildVersion;
        final minAppBuildNumber = getMinAppBuildNumber(
          remoteConfigStore: remoteConfigStore,
          installerStore: Env.buildInfo.installerStore,
        );
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
                      maxLines: 4,
                      fontSize: 18,
                    ),
                    const SizedBox(height: 40),
                    EasyButton(
                      onPressed: () async {
                        try {
                          if (Env.buildInfo.installerStore
                                  ?.toLowerCase()
                                  .contains(windowsStandAloneProductId.toLowerCase()) ??
                              false) {
                            await openUrlLink(Uri.parse(windowsGithubDownloadLink));
                          } else {
                            await openAppStorePage();
                          }
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

  String getMinAppBuildNumber({
    required RemoteConfigStore remoteConfigStore,
    required String? installerStore,
  }) {
    if (Platform.isAndroid) {
      return remoteConfigStore.minAndroidBuildNumber;
    } else if (Platform.isIOS) {
      return remoteConfigStore.minIosBuildNumber;
    } else if (Platform.isMacOS) {
      return remoteConfigStore.minMacosBuildNumber;
    } else if (Platform.isWindows) {
      if (installerStore?.toLowerCase().contains(windowsStandAloneProductId.toLowerCase()) ??
          false) {
        return remoteConfigStore.minWindowsStandAloneBuildNumber;
      }
      return remoteConfigStore.minWindowsBuildNumber;
    }
    return '0';
  }
}
