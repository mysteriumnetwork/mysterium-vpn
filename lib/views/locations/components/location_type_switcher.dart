import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class LocationTypeSwitcher extends StatefulWidget {
  const LocationTypeSwitcher({
    required this.value,
    required this.onChanged,
    required this.options,
    super.key,
  });

  final IPType value;
  final List<IPType> options;
  final ValueChanged<IPType> onChanged;

  @override
  State<LocationTypeSwitcher> createState() => _LocationTypeSwitcherState();
}

class _LocationTypeSwitcherState extends State<LocationTypeSwitcher> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.options.length,
      vsync: this,
      initialIndex: _indexOfValue(widget.value),
    );
  }

  @override
  void didUpdateWidget(covariant LocationTypeSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options.length != oldWidget.options.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.options.length,
        vsync: this,
        initialIndex: _indexOfValue(widget.value),
      );
    } else {
      final newIndex = _indexOfValue(widget.value);
      if (_controller.index != newIndex) {
        _controller.index = newIndex;
      }
    }
  }

  int _indexOfValue(IPType type) {
    final index = widget.options.indexOf(type);
    return index == -1 ? 0 : index;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TabBar(
    controller: _controller,
    onTap: widget.options.length <= 1
        ? null
        : (index) {
            if (widget.options[index] != widget.value) {
              widget.onChanged(widget.options[index]);
            }
          },
    tabs: [
      for (final option in widget.options)
        Tab(
          text: switch (option) {
            IPType.datacenter => LocaleKeys.ipTypeDataCenter.tr(),
            _ =>
              widget.options.length > 1
                  ? LocaleKeys.ipTypeResidential.tr()
                  : LocaleKeys.allLocations.tr(),
          },
        ),
    ],
  );
}
