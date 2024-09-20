import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
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

  @override
  Widget build(BuildContext context) => DropdownButton<T>(
        isExpanded: true,
        value: value,
        icon: const Icon(Icons.arrow_drop_down),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        underline: const SizedBox.shrink(),
        onChanged: onChanged,
        onTap: onTap,
        items: items,
      )
          .width(checkMediaWidth(context, 750) ? double.infinity : 220)
          .padding(horizontal: 10)
          .decorated(
            color: Theme.of(context).colorScheme.brightness == Brightness.dark
                ? Palette.black
                : Palette.lightGrey,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          );
}
