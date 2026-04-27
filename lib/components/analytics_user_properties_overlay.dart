import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/date.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnalyticsUserPropertiesOverlay extends HookConsumerWidget {
  const AnalyticsUserPropertiesOverlay({required this.onDismissPressed, super.key});

  final VoidCallback onDismissPressed;

  static void show(BuildContext context) {
    final overlay = Overlay.of(context);
    OverlayEntry? entry;

    void handleDismiss() {
      entry?.remove();
      entry = null;
    }

    entry ??= OverlayEntry(
      builder: (_) => AnalyticsUserPropertiesOverlay(onDismissPressed: handleDismiss),
    );

    overlay.insert(entry!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProperties = _useAnalyticsUserProperties();

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
                          children: [
                            IconButton(
                              color: theme.textTheme.bodyLarge?.color,
                              onPressed: onDismissPressed,
                              icon: const Icon(Icons.close),
                            ),
                            Expanded(
                              child: Text(
                                'Analytics User Properties',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.of(context).textMd.bold,
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
                _UserPropertiesList(items: userProperties),
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

List<AnalyticsUserProperty> _useAnalyticsUserProperties() {
  final context = useContext();
  final properties = useState<List<AnalyticsUserProperty>>([]);
  useEffect(() {
    final ref = ProviderScope.containerOf(context, listen: false);
    return ref.read(analyticsStorePOD).watchUserProperties().listen((entry) {
      properties.value = [...properties.value, entry];
    }).cancel;
  }, [properties, context]);

  return properties.value;
}

class _UserPropertiesList extends StatelessWidget {
  const _UserPropertiesList({required this.items});

  final List<AnalyticsUserProperty> items;

  @override
  Widget build(BuildContext context) => SliverList.separated(
    itemCount: items.length,
    separatorBuilder: (_, _) =>
        Divider(thickness: 0.5, color: Palette.grayPurple.shade300, height: 0),
    itemBuilder: (context, index) {
      final item = items[index];
      return _UserPropertyListItem(property: item);
    },
  );
}

class _UserPropertyListItem extends StatelessWidget {
  const _UserPropertyListItem({required this.property});

  final AnalyticsUserProperty property;

  @override
  Widget build(BuildContext context) {
    final textStyles = TextStyles.of(context);
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        Icons.account_box,
        color: theme.textTheme.bodyLarge?.color?.withValues(alpha: .7),
      ),
      titleAlignment: ListTileTitleAlignment.titleHeight,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${property.name24chars}: ',
                  style: textStyles.textMd.bold.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: .7),
                  ),
                ),
                TextSpan(
                  text: property.value36chars,
                  style: textStyles.textMd.bold.copyWith(color: Palette.brand),
                ),
              ],
            ),
          ),
          Text(
            'Set at: ${property.setAt.formatWithDayAndTime()}',
            style: textStyles.textSm.regular.copyWith(color: theme.palette.textSecondary),
          ),
        ],
      ),
    );
  }
}
