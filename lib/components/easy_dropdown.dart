import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DropdownButton<T>(
          isExpanded: true,
          value: value,
          icon: Icon(UntitledUI.chevron_down, size: 20, color: theme.palette.iconTertiary),
          disabledHint:
              items.where((item) => item.value == value).firstOrNull?.child ??
              Text(
                value.toString(),
                style: TextStyle(color: theme.palette.textTertiary, fontSize: 16),
              ),
          style: TextStyle(color: theme.palette.textTertiary, fontSize: 16),
          borderRadius: BorderRadius.circular(8),
          underline: const SizedBox.shrink(),
          onChanged: onChanged,
          onTap: onTap,
          items: items,
        )
        .width(220)
        .height(40)
        .padding(horizontal: 12)
        .decorated(
          color: theme.palette.bgPrimary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.palette.borderPrimary),
          boxShadow: const [
            BoxShadow(color: Color(0x0D0A0D12), blurRadius: 2, offset: Offset(0, 1)),
          ],
        )
        .opacity(isDisabled ? 0.6 : 1.0);
  }
}
