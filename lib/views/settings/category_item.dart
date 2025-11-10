import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  Color _backgroundColor(BuildContext context) {
    if (context.c.isDarkMode) {
      return Palette.darkIndigo;
    }
    if (isSelected) {
      return Palette.white;
    }
    return Palette.grayContainer;
  }

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              _SelectionIndicator(
                isSelected: isSelected,
              ).paddingDirectional(end: 14),
              EasyText(
                title,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 16,
                color: isSelected ? Palette.purple : Theme.of(context).tabBarTheme.indicatorColor,
              ).expanded(),
            ],
          ).width(190).height(38).padding(horizontal: 20, vertical: 10),
        ),
      )
          .decorated(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected ? Palette.purple : Palette.transparent,
              width: 1.5,
            ),
          )
          .paddingDirectional(top: 30);
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) => isSelected
      ? const CircleBox(
          size: 10,
          color: Palette.purple,
        )
      : CircleBox(
          size: 4,
          color: Theme.of(context).tabBarTheme.indicatorColor ?? Palette.purple,
        );
}
