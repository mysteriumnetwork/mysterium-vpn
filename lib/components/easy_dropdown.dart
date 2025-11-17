import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:styled_widget/styled_widget.dart';

class EasyDropdown<T> extends StatelessWidget {
  const EasyDropdown({
    required this.items,
    required this.onChanged,
    required this.value,
    this.onTap,
    super.key,
  });

  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final T value;
  final VoidCallback? onTap;

  bool get isDisabled => onChanged == null;

  @override
  Widget build(BuildContext context) => DropdownButton<T>(
        isExpanded: true,
        value: value,
        icon: Icon(
          Icons.arrow_drop_down,
          color: isDisabled ? Palette.lightBlack.withValues(alpha: .3) : Palette.lightBlack,
        ),
        disabledHint: Text(
          value.toString(),
          style: TextStyle(
            color: Palette.lightBlack.withValues(alpha: .3),
          ),
        ),
        style: TextStyle(
          color: isDisabled ? Palette.lightBlack.withValues(alpha: .3) : Palette.lightBlack,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        underline: const SizedBox.shrink(),
        onChanged: onChanged,
        onTap: onTap,
        items: items,
      )
          .width(checkMediaWidth(context, 750) ? double.infinity : 220)
          .height(36)
          .padding(horizontal: 10)
          .decorated(
            color: context.c.isDarkMode ? Palette.black : Palette.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: isDisabled ? Palette.lightBlack.withValues(alpha: .3) : Palette.lightBlack,
            ),
          )
          .opacity(isDisabled ? 0.6 : 1.0);
}
