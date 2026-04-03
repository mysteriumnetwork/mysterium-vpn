import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsRefreshButton extends HookConsumerWidget {
  const LocationsRefreshButton({
    this.outlinedButton = false,
    this.minimumSize = const Size(100, 36),
    this.textScaleGroup,
    this.borderRadius,
    super.key,
  });

  final bool outlinedButton;
  final Size minimumSize;
  final AutoSizeGroup? textScaleGroup;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final refreshFuture = useState<Future<void>?>(null);
    final isRefreshing = useFuture(refreshFuture.value).connectionState == ConnectionState.waiting;

    void handleRefresh() {
      refreshFuture.value = locationsStore.refreshAll();
    }

    return ButtonSecondary(
      size: ButtonSize.small,
      decoration: const ButtonDecoration(padding: EdgeInsets.symmetric(horizontal: 16)),
      loading: isRefreshing ? const ButtonLoading() : null,
      onPressed: isRefreshing ? null : handleRefresh,
      child: Text(LocaleKeys.refresh.tr()),
    );
  }
}
