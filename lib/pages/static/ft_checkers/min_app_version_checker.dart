import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Checks if the current app version is greater than or equal to the minimum required app version.
/// Works only with PROD flavor.
class MinAppVersionChecker extends StatefulWidget {
  const MinAppVersionChecker({required this.child, super.key});

  final Widget child;

  @override
  State<MinAppVersionChecker> createState() => _MinAppVersionCheckerState();
}

class _MinAppVersionCheckerState extends State<MinAppVersionChecker> {
  final _remoteConfigStore = getIt<RemoteConfigStore>();
  bool _canContinue = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Observer(
      builder: (context) {
        final currentBuildVersion = Env.buildInfo.buildVersion;
        final minAppBuildNumber = _getMinAppBuildNumber(
          remoteConfigStore: _remoteConfigStore,
          installerStore: Env.buildInfo.installerStore,
        );
        if (!isCurrentVersionBehind(
              currentAppVersion: currentBuildVersion,
              comparisonVersion: minAppBuildNumber,
            ) ||
            _canContinue) {
          return widget.child;
        } else {
          return ColoredScaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xl2),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: theme.spacing.xl6),
                      const Logo(),
                      const Spacer(),
                      Text(
                        LocaleKeys.featureToggleMinVersionNotSatisfied.tr(),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textStyles.textLg.regular.copyWith(
                          color: theme.palette.textPrimary,
                        ),
                      ),
                      SizedBox(height: theme.spacing.md),
                      ButtonPrimary(
                        onPressed: () async {
                          try {
                            if (Env.buildInfo.installerStore?.toLowerCase().contains(
                                  windowsStandAloneProductId.toLowerCase(),
                                ) ??
                                false) {
                              await openUrlLink(Uri.parse(windowsGithubDownloadLink));
                            } else {
                              await openAppStorePage();
                            }
                          } catch (e) {
                            // Unable to open the store, unblock the user
                            setState(() => _canContinue = true);
                          }
                        },
                        child: Text(LocaleKeys.buttonUpdateApp.tr()),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  String _getMinAppBuildNumber({
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
