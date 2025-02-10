import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/ab_test_hook.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn/components/inherited/parent_scroll_controller.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_mobile_header.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SubscriptionMobileScaffold extends HookConsumerWidget {
  const SubscriptionMobileScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final variant = useABTest((store) => store.subscriptionFlowVariant);
    final controller = useScrollController();

    final (headerKey, headerBox) = useRenderObject<RenderBox>();
    final headerSpacing = useMemoized(() => (headerBox?.size.height ?? 0) + 24, [headerBox?.size]);
    final offset = useListenableSelector<double>(controller, () {
      if (variant == 'E' || !controller.hasClients || controller.positions.isEmpty) {
        return 0.0;
      }

      final position = controller.positions.first;
      return max(position.pixels - position.maxScrollExtent, 0);
    });

    return DecoratedBox(
      decoration: switch (variant) {
        'E' => const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1E1632), Color(0xff47215E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        _ => const BoxDecoration(),
      },
      child: ParentScrollController(
        controller: controller,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(color: theme.colorScheme.surface),
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
                      child: SafeArea(
                        key: headerKey,
                        bottom: false,
                        child: const SubscriptionMobileHeader(),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(top: headerSpacing),
                      sliver: SliverStack(
                        children: [
                          if (variant != 'E')
                            const SliverPositioned.fill(
                              child: SliverFillRemaining(
                                hasScrollBody: false,
                                child: _SheetBackground(),
                              ),
                            ),
                          const SliverToBoxAdapter(
                            child: SubscriptionStatusContainer(
                              child: SubscriptionForm(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetBackground extends StatelessWidget {
  const _SheetBackground();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }
}
