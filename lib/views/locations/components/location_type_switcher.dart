import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationTypeSwitcher extends StatefulWidget {
  const LocationTypeSwitcher({
    required this.value,
    required this.onChanged,
    required this.options,
    this.favoriteLocked = false,
    this.activeTabTrailing,
    super.key,
  });

  final LocationsTab value;
  final List<LocationsTab> options;
  final ValueChanged<LocationsTab> onChanged;

  /// Shows a lock next to the Favorite tab label (plan doesn't allow the
  /// feature). The tab stays tappable so the locked state can explain itself.
  final bool favoriteLocked;

  /// Optional widget rendered next to the label of the active tab — e.g. a
  /// refresh action that applies to the currently selected type.
  final Widget? activeTabTrailing;

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

  int _indexOfValue(LocationsTab tab) {
    final index = widget.options.indexOf(tab);
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Theme.of(context).spacing.s,
            children: [
              if (option == LocationsTab.favorite && widget.favoriteLocked)
                const Icon(UntitledUI.lock_01, size: 16),
              Flexible(child: Text(_label(option), overflow: TextOverflow.ellipsis)),
              if (widget.activeTabTrailing != null && option == widget.value)
                widget.activeTabTrailing!,
            ],
          ),
        ),
    ],
  );

  String _label(LocationsTab option) => switch (option) {
    LocationsTab.datacenter => S.current.ipTypeDataCenterTab,
    LocationsTab.favorite => S.current.favoriteIpsTab,
    LocationsTab.residential => S.current.ipTypeResidentialTab,
  };
}
