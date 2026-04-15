import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnalyticsLoggerOverlay extends StatefulWidget {
  const AnalyticsLoggerOverlay({required this.onDismissPressed, super.key});

  final VoidCallback onDismissPressed;

  static void show(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? entry;

    void handleDismiss() {
      entry?.remove();
      entry = null;
    }

    entry ??= OverlayEntry(builder: (_) => AnalyticsLoggerOverlay(onDismissPressed: handleDismiss));

    overlay.insert(entry!);
  }

  @override
  State<AnalyticsLoggerOverlay> createState() => _AnalyticsLoggerOverlayState();
}

class _AnalyticsLoggerOverlayState extends State<AnalyticsLoggerOverlay> {
  final _analyticsStore = getIt<AnalyticsStore>();
  Set<AnalyticsLogType> _types = {AnalyticsLogType.screenView, AnalyticsLogType.event};
  List<AnalyticsLogEntry> _allLogs = [];
  StreamSubscription<AnalyticsLogEntry>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _analyticsStore.watchLogs().listen((entry) {
      setState(() {
        _allLogs = [..._allLogs, entry];
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<AnalyticsLogEntry> get _filteredLogs =>
      _allLogs.where((it) => _types.contains(it.type)).toList().reversed.toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logs = _filteredLogs;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverStack(
            children: [
              SliverPositioned.fill(child: ColoredBox(color: theme.palette.backgroundColor)),
              SliverSafeArea(
                bottom: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(top: 24),
                  sliver: SliverPinnedHeader(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: theme.palette.backgroundColor),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Row(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              color: theme.textTheme.bodyLarge?.color,
                              onPressed: widget.onDismissPressed,
                              icon: const Icon(Icons.close),
                            ),
                            Expanded(
                              child: _TypePicker(
                                selected: _types,
                                onChanged: (value) => setState(() => _types = value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SliverClip(
            child: MultiSliver(
              children: [
                const SizedBox(height: 12),
                _LogsList(items: logs),
                const SliverSafeArea(
                  top: false,
                  sliver: SliverToBoxAdapter(child: SizedBox(height: 32)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypePicker extends StatelessWidget {
  const _TypePicker({required this.selected, required this.onChanged});

  final Set<AnalyticsLogType> selected;
  final ValueChanged<Set<AnalyticsLogType>> onChanged;

  @override
  Widget build(BuildContext context) {
    void handleToggleItem(AnalyticsLogType item) {
      final selected = {...this.selected};
      if (!selected.add(item)) {
        selected.remove(item);
      }
      onChanged(selected);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Wrap(
        spacing: 12,
        children: [
          for (final entry in AnalyticsLogType.values)
            _TypeItem(
              item: entry,
              selected: selected.contains(entry),
              onTap: () => handleToggleItem(entry),
            ),
        ],
      ),
    );
  }
}

class _TypeItem extends StatelessWidget {
  const _TypeItem({required this.item, required this.selected, required this.onTap});

  final AnalyticsLogType item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          IgnorePointer(
            child: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: selected,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (_) {},
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          Flexible(child: EasyText(item.label, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}

class _LogsList extends StatelessWidget {
  const _LogsList({required this.items});

  final List<AnalyticsLogEntry> items;

  @override
  Widget build(BuildContext context) => SliverList.separated(
    itemCount: items.length,
    separatorBuilder: (_, _) => const Divider(thickness: 0.5, color: Palette.lightBlue, height: 0),
    itemBuilder: (context, index) {
      final item = items[index];
      return _LogListItem(value: item);
    },
  );
}

class _LogListItem extends StatelessWidget {
  const _LogListItem({required this.value});

  final AnalyticsLogEntry value;

  @override
  Widget build(BuildContext context) {
    final params = value.params;
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        value.type.icon,
        color: switch (value.type) {
          AnalyticsLogType.error => Colors.red,
          _ => theme.textTheme.bodyLarge?.color?.withValues(alpha: .7),
        },
      ),
      titleAlignment: ListTileTitleAlignment.titleHeight,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EasyText(
            [value.timestamp.formatWithDay(), value.timestamp.formatWithTime()].join(', '),
            fontSize: 10,
            color: theme.palette.subtitleColor,
          ),
          EasyText(value.message, fontWeight: FontWeight.w700, fontSize: 14, minFontSize: 14),
        ],
      ),
      subtitle: params != null ? _ParamsView(params: params) : const SizedBox.shrink(),
    );
  }
}

class _ParamsView extends StatefulWidget {
  const _ParamsView({required this.params});

  final Map<String, Object?> params;

  @override
  State<_ParamsView> createState() => _ParamsViewState();
}

class _ParamsViewState extends State<_ParamsView> {
  final _group = AutoSizeGroup();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < widget.params.length; i++)
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                color: Palette.lightBlue,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Palette.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: EasyText(
                    widget.params.keys.elementAt(i),
                    autoSizeGroup: _group,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Palette.white,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: EasyText(
                      '${widget.params.values.elementAt(i)}',
                      autoSizeGroup: _group,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

extension _AnalyticsLogTypeExt on AnalyticsLogType {
  IconData get icon {
    switch (this) {
      case AnalyticsLogType.event:
        return Icons.info_outline;
      case AnalyticsLogType.error:
        return Icons.error_outline;
      case AnalyticsLogType.message:
        return Icons.notes_outlined;
      case AnalyticsLogType.screenView:
        return Icons.screen_search_desktop_outlined;
    }
  }

  String get label {
    switch (this) {
      case AnalyticsLogType.event:
        return 'Event';
      case AnalyticsLogType.error:
        return 'Error';
      case AnalyticsLogType.message:
        return 'Message';
      case AnalyticsLogType.screenView:
        return 'Screen View';
    }
  }
}
