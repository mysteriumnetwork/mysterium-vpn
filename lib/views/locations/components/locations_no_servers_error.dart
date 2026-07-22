import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationsNoServersError extends ConsumerWidget {
  const LocationsNoServersError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);

    return Observer(
      builder: (context) {
        final isRefreshing =
            locationsStore.residentialLocationsFuture.status == FutureStatus.pending ||
            locationsStore.dcLocationsFuture.status == FutureStatus.pending;
        return ErrorRetryView(
          title: S.current.noServersAvailable,
          message: S.current.noServersAvailableSub,
          retryLabel: S.current.retryBtn,
          onRetry: locationsStore.refreshAll,
          loading: isRefreshing,
        );
      },
    );
  }
}
