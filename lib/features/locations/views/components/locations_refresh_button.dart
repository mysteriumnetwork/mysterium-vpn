import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsRefreshButton extends StatefulWidget {
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
  State<LocationsRefreshButton> createState() => _LocationsRefreshButtonState();
}

class _LocationsRefreshButtonState extends State<LocationsRefreshButton> {
  final _locationsStore = getIt<LocationsStore>();
  bool _isRefreshing = false;

  void _handleRefresh() {
    final future = _locationsStore.refreshAll();
    setState(() => _isRefreshing = true);
    future.whenComplete(() {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) => ButtonSecondary(
    size: ButtonSize.small,
    decoration: ButtonDecoration(
      padding: EdgeInsets.symmetric(horizontal: Theme.of(context).spacing.md),
    ),
    loading: _isRefreshing ? const ButtonLoading() : null,
    onPressed: _isRefreshing ? null : _handleRefresh,
    child: Text(LocaleKeys.refresh.tr()),
  );
}
