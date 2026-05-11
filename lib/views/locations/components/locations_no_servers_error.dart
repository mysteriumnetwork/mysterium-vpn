import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsNoServersError extends ConsumerWidget {
  const LocationsNoServersError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final locationsStore = ref.watch(locationsStorePOD);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

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
            style: theme.textStyles.textSm.semibold.copyWith(color: palette.textSecondary),
          ),
          SizedBox(height: theme.spacing.xs),
          Text(
            LocaleKeys.noServersAvailableSub.tr(),
            textAlign: TextAlign.center,
            style: theme.textStyles.textSm.regular.copyWith(color: palette.textTertiary),
          ),
          SizedBox(height: theme.spacing.xl),
          Observer(
            builder: (context) {
              final isRefreshing =
                  locationsStore.residentialLocationsFuture.status == FutureStatus.pending ||
                  locationsStore.dcLocationsFuture.status == FutureStatus.pending;
              return SizedBox(
                width: isDesktop ? null : double.infinity,
                child: ButtonSecondary(
                  loading: isRefreshing ? const ButtonLoading() : null,
                  onPressed: locationsStore.refreshAll,
                  child: Text(LocaleKeys.retryBtn.tr()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
