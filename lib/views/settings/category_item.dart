import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
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
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isSelected ? Palette.purple : Theme.of(context).indicatorColor,
              ).expanded(),
            ],
          ).width(190).height(38).padding(horizontal: 20, vertical: 10),
        ),
      )
          .decorated(
            color:
                isSelected ? Theme.of(context).colorScheme.scrim : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(100),
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
          size: 6,
          color: Theme.of(context).indicatorColor,
        );
}
