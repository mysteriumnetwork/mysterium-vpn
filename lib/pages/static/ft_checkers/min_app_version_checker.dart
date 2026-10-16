import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

const _contentMaxWidth = 420.0;

/// Checks if the current app version is greater than or equal to the minimum required app version.
/// Works only with PROD flavor.
class MinAppVersionChecker extends ConsumerWidget {
  const MinAppVersionChecker({required this.child, this.operatingSystem, super.key});

  final Widget child;

  /// Overrides `Platform.operatingSystem`. Injectable because the suite runs on
  /// Linux in CI, which ships no minimum and so can never render the wall.
  @visibleForTesting
  final String? operatingSystem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);

    return Observer(
      builder: (context) {
        final currentBuildVersion = Env.buildInfo.buildVersion;
        final minAppBuildNumber = getMinAppBuildNumber(remoteConfigStore: remoteConfigStore);
        if (!isCurrentVersionBehind(
          currentAppVersion: currentBuildVersion,
          comparisonVersion: minAppBuildNumber,
        )) {
          return child;
        }
        return _UpdateWall(currentVersion: currentBuildVersion, requiredVersion: minAppBuildNumber);
      },
    );
  }

  String getMinAppBuildNumber({required RemoteConfigStore remoteConfigStore}) =>
      switch (operatingSystem ?? Platform.operatingSystem) {
        'android' => remoteConfigStore.minAndroidBuildNumber,
        'ios' => remoteConfigStore.minIosBuildNumber,
        'macos' => remoteConfigStore.minMacosBuildNumber,
        'windows' => remoteConfigStore.minWindowsStandAloneBuildNumber,
        // Linux ships no minimum, so it is never gated.
        _ => '0',
      };
}

/// Blocking screen shown when the installed build is below the remote minimum.
/// States what is wrong, which versions are involved, and the one way out.
class _UpdateWall extends StatelessWidget {
  const _UpdateWall({required this.currentVersion, required this.requiredVersion});

  final String currentVersion;
  final String requiredVersion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModalScaffold(
      // Transparent so the scaffold's gradient runs unbroken behind it, the
      // same reason ModalAppbar uses this colour.
      appbar: Header.logo(showBackButton: false, backgroundColor: Palette.transparent),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedIcon(
                  icon: UntitledUI.arrow_circle_up,
                  decoration: IconDecoration(
                    iconSize: 32,
                    iconColor: theme.palette.iconBrandPrimary,
                    backgroundColor: theme.palette.bgBrand,
                    padding: EdgeInsets.all(theme.spacing.xl),
                    borderRadius: const BorderRadius.all(Radius.kFull),
                  ),
                ),
                SizedBox(height: theme.spacing.xl2),
                Text(
                  S.current.updateRequiredTitle,
                  textAlign: TextAlign.center,
                  style: theme.textStyles.displayXlg.bold,
                ),
                SizedBox(height: theme.spacing.ms),
                Text(
                  S.current.featureToggleMinVersionNotSatisfied,
                  textAlign: TextAlign.center,
                  style: theme.textStyles.textMd.regular.copyWith(
                    color: theme.palette.textSecondary,
                  ),
                ),
                SizedBox(height: theme.spacing.xl3),
                DetailCard(
                  title: S.current.updateCurrentVersionLbl,
                  trailing: Text(
                    currentVersion,
                    style: theme.textStyles.textMd.regular.copyWith(
                      color: theme.palette.textErrorPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  position: SettingsCardPosition.top,
                ),
                DetailCard(
                  title: S.current.updateRequiredVersionLbl,
                  trailing: Text(
                    requiredVersion,
                    style: theme.textStyles.textMd.semibold.copyWith(
                      color: theme.palette.textBrandPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  position: SettingsCardPosition.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
      footer: ModalFooter(
        children: [
          ButtonPrimary(
            size: ButtonSize.large,
            onPressed: openAppUpdateSource,
            child: Text(S.current.buttonUpdateApp),
          ),
        ],
      ),
    );
  }
}
