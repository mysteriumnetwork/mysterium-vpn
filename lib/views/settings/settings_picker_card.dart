import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// A settings card that shows an [EasyDropdown] on desktop and opens a
/// [showPickerBottomSheet] on mobile. Handles the desktop/mobile presentation
/// split so callers only provide data and callbacks.
class SettingsPickerCard<T> extends StatelessWidget {
  const SettingsPickerCard({
    required this.title,
    required this.position,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.enabled = true,
    this.isLoading = false,
    this.subtitleOf,
    this.customLabel,
    this.sheetKey,
    this.itemKeyOf,
    super.key,
  });

  final String title;
  final SettingsCardPosition position;
  final T value;
  final List<T> items;
  final String Function(T) labelOf;
  final FutureOr<void> Function(T) onChanged;
  final bool enabled;
  final bool isLoading;
  final String? Function(T)? subtitleOf;
  final String Function(T)? customLabel;

  /// Test key for the picker bottom sheet opened on mobile.
  final Key? sheetKey;

  /// Test key for each picker option, derived from the item.
  final Key? Function(T)? itemKeyOf;

  @override
  Widget build(BuildContext context) {
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);

    if (isDesktop) {
      return SettingsCard(
        title: title,
        position: position,
        trailing: EasyDropdown<T>(
          value: value,
          onChanged: enabled && !isLoading
              ? (T? v) {
                  if (v != null) {
                    onChanged(v);
                  }
                }
              : null,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(labelOf(item)),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    void onTap() => showPickerBottomSheet<T>(
      context: context,
      title: title,
      items: items,
      value: value,
      labelOf: customLabel ?? labelOf,
      onChanged: onChanged,
      subtitleOf: subtitleOf,
      sheetKey: sheetKey,
      itemKeyOf: itemKeyOf,
    );

    final tap = enabled && !isLoading ? onTap : null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: tap,
      child: SettingsCard(
        title: title,
        subtitle: labelOf(value),
        position: position,
        trailing: isLoading
            ? const LoadingIndicator()
            : IconButton(
                icon: Icon(UntitledUI.chevron_right, size: 24, color: theme.palette.iconTertiary),
                onPressed: tap,
              ),
      ),
    );
  }
}
