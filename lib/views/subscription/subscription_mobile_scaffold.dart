import 'dart:math';

import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/close_button.dart';
import 'package:mysterium_vpn/components/inherited/parent_scroll_controller.dart';
import 'package:mysterium_vpn/components/sheet_scaffold.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/widgets/limited_offer_view.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_form.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_mobile_header.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_sales_view.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SubscriptionMobileScaffold extends HookConsumerWidget {
  const SubscriptionMobileScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useScrollController();
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    final offset = useListenableSelector<double>(controller, () {
      if (!controller.hasClients || controller.positions.isEmpty) {
        return 0.0;
      }

      final position = controller.positions.first;
      return max(position.pixels - position.maxScrollExtent, 0);
    });

    return ParentScrollController(
      controller: controller,
      child: Observer(
        builder: (context) {
          final showSalesView = remoteConfigStore.showSalesView &&
              (subscriptionStore.highlightedProduct?.hasIntroductoryPrice ?? false);
          final showLimitedOfferView = remoteConfigStore.limitedTimeOfferExpiryDate != null &&
              remoteConfigStore.limitedTimeOfferExpiryDate!.isAfter(DateTime.now());
          final pricing = showLimitedOfferView
              ? const _LimitedOfferPricing()
              : showSalesView
                  ? const _SalesPricing()
                  : const _RegularPricing();

          return Stack(
            children: [
              if (pricing is _RegularPricing)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: theme.colorScheme.surface),
                    child: SizedBox(height: offset + kToolbarHeight),
                  ),
                )
              else if (pricing is _SalesPricing)
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff1E1632), Color(0xff47215E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              if (pricing is _LimitedOfferPricing)
                pricing
              else
                CustomScrollView(
                  controller: controller,
                  slivers: [pricing],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _RegularPricing extends HookWidget {
  const _RegularPricing();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (headerKey, headerBox) = useRenderObject<RenderBox>();
    final headerSpacing = useMemoized(() => (headerBox?.size.height ?? 0) + 24, [headerBox?.size]);

    return SliverStack(
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
              SliverPositioned.fill(
                child: SliverFillRemaining(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                  ),
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
    );
  }
}

class _SalesPricing extends HookWidget {
  const _SalesPricing();

  @override
  Widget build(BuildContext context) => SliverStack(
        children: const [
          SliverPositioned(
            top: 0,
            right: 0,
            child: SliverPinnedHeader(child: CloseButton()),
          ),
          SliverToBoxAdapter(
            child: SubscriptionStatusContainer(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: SubscriptionSalesView(),
              ),
            ),
          ),
        ],
      );
}

class _LimitedOfferPricing extends HookConsumerWidget {
  const _LimitedOfferPricing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.palette.limitedOfferBackgroundColor,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: SheetScaffold(
        sheetColor: theme.palette.limitedOfferSheetColor,
        scaffoldColor: theme.palette.limitedOfferBackgroundColor,
        header: const SubscriptionMobileHeader(),
        sliver: SliverToBoxAdapter(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: height),
            child: const SubscriptionStatusContainer(child: LimitedOfferView()),
          ),
        ),
      ),
    );
  }
}
