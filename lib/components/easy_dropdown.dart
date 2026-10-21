import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Total control width; no spacing token reaches it.
const double _kFieldWidth = 244;

class EasyDropdown<T> extends StatefulWidget {
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

  /// Mirrors `DropdownButton`'s own enabled rule, which also needs items.
  bool get isDisabled => onChanged == null || items.isEmpty;

  @override
  State<EasyDropdown<T>> createState() => _EasyDropdownState<T>();
}

class _EasyDropdownState<T> extends State<EasyDropdown<T>> {
  bool _hovered = false;

  /// Hover-independent, so it is built per theme rather than per pointer
  /// crossing — `copyWith` allocates the whole ThemeData.
  late ThemeData _menuTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    final palette = theme.palette;
    _menuTheme = theme.copyWith(
      hoverColor: palette.bgPrimaryHover,
      focusColor: palette.bgPrimaryHover,
      highlightColor: palette.bgPrimaryHover,
      splashColor: palette.bgPrimaryHover,
    );
  }

  Widget _disabledHint(Palette palette) =>
      widget.items.where((item) => item.value == widget.value).firstOrNull?.child ??
      Text(widget.value.toString(), style: TextStyle(color: palette.textTertiary, fontSize: 16));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final highlighted = _hovered && !widget.isDisabled;

    return Opacity(
      opacity: widget.isDisabled ? 0.6 : 1.0,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: highlighted ? palette.bgPrimaryHover : palette.bgPrimary,
            borderRadius: const BorderRadius.all(Radius.kXs),
            border: Border.all(color: palette.borderPrimary),
            boxShadow: [
              BoxShadow(color: palette.shadowXs, blurRadius: 2, offset: const Offset(0, 1)),
            ],
          ),
          child: SizedBox(
            width: _kFieldWidth,
            height: theme.spacing.xl4,
            // Menu rows highlight with the same tokens as the closed control.
            child: Theme(
              data: _menuTheme,
              child: DropdownButton<T>(
                isExpanded: true,
                // Inside the button, so the gutter takes taps as well as paint.
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms),
                value: widget.value,
                icon: Icon(UntitledUI.chevron_down, size: 20, color: palette.iconTertiary),
                disabledHint: widget.isDisabled ? _disabledHint(palette) : null,
                style: TextStyle(color: palette.textTertiary, fontSize: 16),
                borderRadius: const BorderRadius.all(Radius.kXs),
                dropdownColor: palette.bgPrimary,
                underline: const SizedBox.shrink(),
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                items: widget.items,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
