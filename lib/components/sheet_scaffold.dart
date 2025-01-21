import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn/components/page_header.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SheetScaffold extends HookWidget {
  const SheetScaffold({
    required this.sliver,
    this.headerTitle = '',
    this.header,
    super.key,
  });

  final Widget sliver;
  final String headerTitle;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final (headerKey, headerBox) = useRenderObject<RenderBox>();
    final header = this.header ?? PageHeader(headerTitle: headerTitle);
    final headerSpacing = useMemoized(() => (headerBox?.size.height ?? 0) + 16, [headerBox?.size]);

    final controller = useScrollController();

    final offset = useListenableSelector<double>(controller, () {
      if (!controller.hasClients) {
        return 0.0;
      }
      return max(controller.position.pixels - controller.position.maxScrollExtent, 0);
    });

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(color: theme.primaryColor),
            child: SizedBox(height: offset + 12),
          ),
        ),
        CustomScrollView(
          controller: controller,
          slivers: [
            SliverStack(
              insetOnOverlap: true,
              positionedAlignment: Alignment.topCenter,
              children: [
                SliverPositioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(key: headerKey, bottom: false, child: header),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: headerSpacing),
                  sliver: SliverStack(
                    children: [
                      SliverPositioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      const SliverFillRemaining(hasScrollBody: false),
                      MultiSliver(
                        children: [
                          sliver,
                          SizedBox(height: mediaQuery.padding.bottom + 32),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
