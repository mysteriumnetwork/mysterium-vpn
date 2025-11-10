import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/horizontal_scroll_indicator.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/views/locations/components/recent_location_item.dart';

class RecentLocationsList extends HookWidget {
  const RecentLocationsList({
    required this.items,
    required this.onItemPressed,
    this.constraints = const BoxConstraints(maxHeight: 82),
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final hasIndicator = useResponsiveValue(
      false,
      desktop: true,
      tablet: true,
    );

    final scrollController = useScrollController();

    final child = _List(
      items: items,
      onItemPressed: onItemPressed,
      scrollController: scrollController,
      constraints: constraints,
      clipBehavior: hasIndicator ? Clip.hardEdge : Clip.none,
    );

    if (hasIndicator) {
      return HorizontalScrollIndicator(
        controller: scrollController,
        child: child,
      );
    }

    return child;
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.items,
    required this.onItemPressed,
    required this.scrollController,
    required this.constraints,
    required this.clipBehavior,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final ScrollController scrollController;
  final BoxConstraints constraints;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: constraints,
        child: ListView.separated(
          controller: scrollController,
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          clipBehavior: clipBehavior,
          itemBuilder: (_, index) {
            final item = items[index];
            return Align(
              alignment: Alignment.topLeft,
              child: RecentLocationItem(
                location: item,
                onTap: () => onItemPressed(item),
              ),
            );
          },
        ),
      );
}
