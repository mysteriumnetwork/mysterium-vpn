import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/horizontal_scroll_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shimmer/shimmer.dart';

class UserIntentPicker extends HookWidget {
  const UserIntentPicker({
    required this.onChanged,
    required this.value,
    this.items = UserIntent.values,
    super.key,
  });

  final UserIntent? value;
  final List<UserIntent>? items;
  final ValueChanged<UserIntent?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final hasIndicator = useResponsiveValue(false, desktop: true, tablet: true);

    final child = _List(
      scrollController: scrollController,
      hasIndicator: hasIndicator,
      items: items,
      value: value,
      onChanged: onChanged,
    );

    if (!hasIndicator) {
      return child;
    }

    return HorizontalScrollIndicator(controller: scrollController, child: child);
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.scrollController,
    required this.hasIndicator,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  final ScrollController scrollController;
  final bool hasIndicator;
  final List<UserIntent>? items;
  final UserIntent? value;
  final ValueChanged<UserIntent?>? onChanged;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxHeight: 46),
    child: GestureDetector(
      onVerticalDragUpdate: (_) {},
      child: ListView.separated(
        controller: scrollController,
        clipBehavior: hasIndicator ? Clip.hardEdge : Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: items?.length ?? UserIntent.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (items == null) {
            final theme = Theme.of(context);
            return Shimmer.fromColors(
              baseColor: theme.palette.bgPrimary,
              highlightColor: theme.palette.bgPrimary.darken(20),
              child: IntentTab(
                icon: UntitledUI.marker_pin_04,
                label: LocaleKeys.userIntentNearestLocation.tr(),
              ),
            );
          }

          final item = items![index];
          final isSelected = value == item;
          return IntentTab(
            icon: _iconFor(item),
            label: _labelFor(item),
            status: onChanged == null
                ? IntentTabStatus.disabled
                : isSelected
                ? IntentTabStatus.selected
                : IntentTabStatus.idle,
            onTap: onChanged == null
                ? null
                : () {
                    if (isSelected) {
                      onChanged!(null);
                    } else {
                      onChanged!(item);
                    }
                  },
          );
        },
      ),
    ),
  );

  static IconData _iconFor(UserIntent intent) => switch (intent) {
    UserIntent.bestSpeed => UntitledUI.flash,
    UserIntent.lowLatency => UntitledUI.clock,
    UserIntent.nearestLocation => UntitledUI.marker_pin_04,
    UserIntent.maxPrivacy => UntitledUI.shield_01,
    UserIntent.streaming => UntitledUI.film_01,
    UserIntent.p2p => UntitledUI.users_02,
  };

  static String _labelFor(UserIntent intent) => switch (intent) {
    UserIntent.bestSpeed => LocaleKeys.userIntentBestSpeed.tr(),
    UserIntent.lowLatency => LocaleKeys.userIntentLowLatency.tr(),
    UserIntent.nearestLocation => LocaleKeys.userIntentNearestLocation.tr(),
    UserIntent.maxPrivacy => LocaleKeys.userIntentMaxPrivacy.tr(),
    UserIntent.streaming => LocaleKeys.userIntentStreaming.tr(),
    UserIntent.p2p => LocaleKeys.userIntentP2P.tr(),
  };
}
