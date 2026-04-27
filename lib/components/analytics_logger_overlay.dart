import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnalyticsLoggerOverlay extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final types = useState({AnalyticsLogType.screenView, AnalyticsLogType.event});
    final logs = _useAnalyticsLogs(types.value);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverStack(
            children: [
              SliverPositioned.fill(child: ColoredBox(color: theme.palette.bgSecondary)),
              SliverSafeArea(
                bottom: false,
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(top: 24),
                  sliver: SliverPinnedHeader(
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: theme.palette.bgSecondary),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        child: Row(
                          spacing: 16,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              color: theme.textTheme.bodyLarge?.color,
                              onPressed: onDismissPressed,
                              icon: const Icon(Icons.close),
                            ),
                            Expanded(
                              child: _TypePicker(
                                selected: types.value,
                                onChanged: (value) => types.value = value,
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

List<AnalyticsLogEntry> _useAnalyticsLogs(Iterable<AnalyticsLogType> types) {
  final context = useContext();
  final logs = useState<List<AnalyticsLogEntry>>([]);
  useEffect(() {
    final ref = ProviderScope.containerOf(context, listen: false);
    return ref.read(analyticsStorePOD).watchLogs().listen((entry) {
      logs.value = [...logs.value, entry];
    }).cancel;
  }, [logs, context]);

  return logs.value.where((it) => types.contains(it.type)).toList().reversed.toList();
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
          Flexible(
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.of(context).textXs.bold,
            ),
          ),
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
    separatorBuilder: (_, _) =>
        Divider(thickness: 0.5, color: Palette.grayPurple.shade300, height: 0),
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
          Text(
            [value.timestamp.formatWithDay(), value.timestamp.formatWithTime()].join(', '),
            style: TextStyles.of(
              context,
            ).textXs.regular.copyWith(fontSize: 10, color: theme.palette.textSecondary),
          ),
          Text(
            value.message,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.of(context).textSm.bold,
          ),
        ],
      ),
      subtitle: params != null ? _ParamsView(params: params) : const SizedBox.shrink(),
    );
  }
}

class _ParamsView extends HookWidget {
  const _ParamsView({required this.params});

  final Map<String, Object?> params;

  @override
  Widget build(BuildContext context) {
    final group = useMemoized(AutoSizeGroup.new);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (var i = 0; i < params.length; i++)
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Palette.grayPurple.shade300,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Palette.brand,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: AutoSizeText(
                      params.keys.elementAt(i),
                      group: group,
                      maxLines: 1,
                      style: TextStyles.of(context).textXs.bold.copyWith(color: Palette.white),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: AutoSizeText(
                        '${params.values.elementAt(i)}',
                        group: group,
                        maxLines: 1,
                        style: TextStyles.of(context).textXs.semibold,
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
