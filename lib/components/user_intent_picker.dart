import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/color_filtered_optional.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/horizontal_scroll_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
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
    final hasIndicator = useResponsiveValue(
      false,
      desktop: true,
      tablet: true,
    );

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

    return HorizontalScrollIndicator(
      controller: scrollController,
      child: child,
    );
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
        child: ListView.separated(
          controller: scrollController,
          clipBehavior: hasIndicator ? Clip.hardEdge : Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: items?.length ?? UserIntent.values.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            if (items == null) {
              final theme = Theme.of(context);
              return Shimmer.fromColors(
                baseColor: theme.colorScheme.secondary,
                highlightColor: theme.colorScheme.secondary.darken(20),
                child: _Item(
                  isEnabled: true,
                  value: UserIntent.nearestLocation,
                  isSelected: false,
                  onPressed: () {},
                ),
              );
            }

            final item = items![index];
            final isSelected = value == item;
            return _Item(
              isEnabled: onChanged != null,
              value: item,
              isSelected: isSelected,
              onPressed: onChanged == null
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
      );
}

class _Item extends StatelessWidget {
  const _Item({
    required this.value,
    required this.isSelected,
    required this.onPressed,
    required this.isEnabled,
  });

  final UserIntent value;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RawMaterialButton(
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      padding: const EdgeInsets.all(12),
      onPressed: onPressed,
      fillColor: isSelected ? theme.palette.highlightColor : theme.colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ColorFilteredOptional(
        colorFilter: isEnabled
            ? null
            : ColorFilter.mode(
                theme.palette.lightTextColor,
                BlendMode.srcIn,
              ),
        child: Row(
          spacing: 6,
          mainAxisSize: MainAxisSize.min,
          children: [
            EasyText(
              switch (value) {
                UserIntent.bestSpeed => LocaleKeys.userIntentBestSpeed.tr(),
                UserIntent.lowLatency => LocaleKeys.userIntentLowLatency.tr(),
                UserIntent.nearestLocation => LocaleKeys.userIntentNearestLocation.tr(),
                UserIntent.maxPrivacy => LocaleKeys.userIntentMaxPrivacy.tr(),
                UserIntent.streaming => LocaleKeys.userIntentStreaming.tr(),
                UserIntent.p2p => LocaleKeys.userIntentP2P.tr(),
              },
              color: isSelected ? Colors.white : theme.palette.secondaryColor,
            ),
            SvgIcon(
              color: isSelected ? Colors.white : theme.palette.highlightColor,
              asset: switch (value) {
                UserIntent.bestSpeed => Asset.icons.flash,
                UserIntent.lowLatency => Asset.icons.clockCircle,
                UserIntent.nearestLocation => Asset.icons.locationPin,
                UserIntent.maxPrivacy => Asset.icons.incognito,
                UserIntent.streaming => Asset.icons.film,
                UserIntent.p2p => Asset.icons.shareCircle,
              },
            ),
          ],
        ),
      ),
    );
  }
}
