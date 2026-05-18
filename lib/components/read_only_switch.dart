import 'package:flutter/material.dart';

/// A Material [Switch] rendered in its active visual state and dimmed to 50 %
/// opacity, with all pointer interaction blocked.
///
/// Used in settings rows that surface a value the user cannot change in-app
/// (e.g. DNS protection, Kill switch, push-notification permission) — keeping
/// the switch in its active palette instead of falling back to Material's
/// disabled gray, then muting the whole thing per the design system.
class ReadOnlySwitch extends StatelessWidget {
  const ReadOnlySwitch({required this.value, super.key});

  /// The value to display. The widget itself never changes it.
  final bool value;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Opacity(
      opacity: 0.5,
      child: Switch(value: value, onChanged: (_) {}),
    ),
  );
}
