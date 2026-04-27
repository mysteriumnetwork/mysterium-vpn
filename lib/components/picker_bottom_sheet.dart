import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Shows a scrollable single-selection picker as a bottom sheet on mobile
/// and a centred dialog on desktop.
///
/// Automatically dismisses after the user selects a value.
FutureOr<void> showPickerBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required T value,
  required FutureOr<void> Function(T) onChanged,
  required String Function(T) labelOf,
  String? Function(T)? subtitleOf,
}) => showBottomSheetDialog(
  context,
  mobileConstraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
  builder: (context) => _PickerSheet<T>(
    title: title,
    items: items,
    value: value,
    onChanged: onChanged,
    labelOf: labelOf,
    subtitleOf: subtitleOf,
  ),
);

// ─── Sheet ────────────────────────────────────────────────────────────────────

class _PickerSheet<T> extends StatefulWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelOf,
    this.subtitleOf,
    super.key,
  });

  final String title;
  final List<T> items;
  final T value;
  final FutureOr<void> Function(T) onChanged;
  final String Function(T) labelOf;
  final String? Function(T)? subtitleOf;

  @override
  State<_PickerSheet<T>> createState() => _PickerSheetState<T>();
}

class _PickerSheetState<T> extends State<_PickerSheet<T>> {
  late T _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  Widget build(BuildContext context) => BottomSheetDialog(
    title: widget.title,
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in widget.items)
          _PickerItem(
            label: widget.labelOf(item),
            subtitle: widget.subtitleOf?.call(item),
            selected: _selected == item,
            onTap: () async {
              setState(() => _selected = item);
              await widget.onChanged(item);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
      ],
    ),
  );
}

// ─── Item ─────────────────────────────────────────────────────────────────────

class _PickerItem extends StatelessWidget {
  const _PickerItem({
    required this.label,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.xl),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: RadioButton(selected: selected),
            ),
            SizedBox(width: theme.spacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textStyles.textMd.medium.copyWith(
                      color: theme.palette.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: theme.spacing.xxs),
                    Text(
                      subtitle!,
                      style: theme.textStyles.textMd.regular.copyWith(
                        color: theme.palette.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
