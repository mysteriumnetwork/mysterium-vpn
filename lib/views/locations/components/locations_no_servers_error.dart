import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsNoServersError extends StatelessWidget {
  const LocationsNoServersError({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedIcon(
            icon: UntitledUI.alert_circle,
            decoration: IconDecoration(
              iconSize: 32,
              iconColor: palette.iconErrorPrimary,
              backgroundColor: palette.bgError,
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(48),
            ),
          ),
          SizedBox(height: theme.spacing.xl),
          Text(
            LocaleKeys.noServersAvailable.tr(),
            textAlign: TextAlign.center,
            style: theme.textStyles.textSm.semibold.copyWith(color: theme.palette.textSecondary),
          ),
          SizedBox(height: theme.spacing.xs),
          Text(
            LocaleKeys.noServersAvailableSub.tr(),
            textAlign: TextAlign.center,
            style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textTertiary),
          ),
          SizedBox(height: theme.spacing.xl),
          ButtonSecondary(onPressed: onRetry, child: Text(LocaleKeys.retryBtn.tr())),
        ],
      ),
    );
  }
}
