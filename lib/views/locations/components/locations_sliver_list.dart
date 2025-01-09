import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

class LocationsSliverList extends StatelessWidget {
  const LocationsSliverList({
    required this.ipType,
    required this.items,
    required this.onItemPressed,
    this.emptyText,
    super.key,
  });

  final List<VPNLocation> items;
  final IPType ipType;
  final String? emptyText;

  final void Function(VPNLocation item) onItemPressed;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && (emptyText?.isNotEmpty ?? false)) {
      return _Empty(text: emptyText!);
    }
    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) {
        final item = items[index];
        return LocationItem(
          location: item,
          onTap: () => onItemPressed(item),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: EasyText(text, color: theme.colorScheme.error, fontWeight: FontWeight.w700),
    );
  }
}
