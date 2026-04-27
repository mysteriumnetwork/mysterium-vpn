import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/date.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AnalyticsUserPropertiesOverlay extends StatefulWidget {
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
  State<AnalyticsUserPropertiesOverlay> createState() => _AnalyticsUserPropertiesOverlayState();
}

class _AnalyticsUserPropertiesOverlayState extends State<AnalyticsUserPropertiesOverlay> {
  final _analyticsStore = getIt<AnalyticsStore>();
  List<AnalyticsUserProperty> _userProperties = [];
  StreamSubscription<AnalyticsUserProperty>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _analyticsStore.watchUserProperties().listen((entry) {
      setState(() {
        _userProperties = [..._userProperties, entry];
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                              onPressed: widget.onDismissPressed,
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
                _UserPropertiesList(items: _userProperties),
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
