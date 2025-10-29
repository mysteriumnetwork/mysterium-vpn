import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

Future<void> showSimpleMenu(
  BuildContext context, {
  required List<SimpleMenuItem> items,
}) async {
  final screenType = ScreenType.of(context);
  if (screenType > ScreenType.mobile) {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Palette.white,
        surfaceTintColor: Palette.white,
        contentPadding: EdgeInsets.zero,
        content: _Body(items: items),
      ),
    );
  } else {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => _Body(items: items),
      backgroundColor: Palette.white,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.items,
  });

  final List<SimpleMenuItem> items;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        bottom: ScreenType.of(context) <= ScreenType.mobile,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: items
                .map<Widget>((item) => _Item(item: item))
                .separateWith(const Divider())
                .toList(),
          ),
        ),
      );
}

class _Item extends StatelessWidget {
  const _Item({required this.item});

  final SimpleMenuItem item;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () {
          if (item.autoDismissOnTap) {
            Navigator.of(context).pop();
          }
          item.onTap();
        },
        title: Text(item.label, style: const TextStyle(color: Palette.midnightCharcoal)),
        trailing: const Icon(Icons.chevron_right, color: Palette.midnightCharcoal),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      );
}

@immutable
class SimpleMenuItem {
  const SimpleMenuItem({
    required this.label,
    required this.onTap,
    this.autoDismissOnTap = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool autoDismissOnTap;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleMenuItem &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          onTap == other.onTap;

  @override
  int get hashCode => label.hashCode ^ onTap.hashCode;
}
