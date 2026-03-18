import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/locations/components/location_item.dart';

class LocationsSliverList extends HookConsumerWidget {
  const LocationsSliverList({
    required this.items,
    required this.onItemPressed,
    this.scrollToSelected = false,
    this.stickyHeaderKey,
    super.key,
  });

  final List<VPNLocation> items;
  final void Function(VPNLocation item) onItemPressed;
  final bool scrollToSelected;

  /// Key of the pinned header widget sitting above this list. Its height is
  /// subtracted from the reveal offset so the selected item appears just below
  /// the header rather than behind it.
  final GlobalKey? stickyHeaderKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final screenType = useScreenType();

    final userExpanded = useMemoized(() => ValueNotifier<Set<String>>({}));
    final userCollapsed = useMemoized(() => ValueNotifier<Set<String>>({}));
    useEffect(
      () => () {
        userExpanded.dispose();
        userCollapsed.dispose();
      },
      const [],
    );

    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final connectingLocation = useComputedValue(() => vpnStore.connectingLocation);
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );

    final priorityCountryCode = selectedLocation?.countryCode ??
        connectingLocation?.countryCode ??
        connectedLocation?.countryCode;

    final lastPriorityRef = useRef<String?>(priorityCountryCode);
    if (priorityCountryCode != null) {
      lastPriorityRef.value = priorityCountryCode;
    }
    final effectivePriorityCountryCode = priorityCountryCode ?? lastPriorityRef.value;

    final priorityIndex = effectivePriorityCountryCode == null
        ? -1
        : items.indexWhere((it) => it.countryCode == effectivePriorityCountryCode);

    final isDesktop = screenType == ScreenType.desktop;

    // Reactively tracks whether the panel is fully open (animation complete).
    final isPanelFullyOpen = ref.watch(
      homeStateProvider.select((s) {
        final pc = s.panelController;
        if (!pc.isAttached) {
          return true;
        }
        return pc.isPanelOpen;
      }),
    );

    final homeState = ref.watch(homeStateProvider);

    useEffect(
      () {
        if (!scrollToSelected || priorityIndex == -1) {
          return null;
        }

        // Already scrolled to this country — don't scroll again.
        // Stored on homeState so it survives widget recreation on tab switch.
        if (homeState.lastScrolledCountryCode == effectivePriorityCountryCode) {
          return null;
        }

        // On mobile wait until the panel animation is fully complete.
        if (!isDesktop && !isPanelFullyOpen) {
          return null;
        }

        homeState.lastScrolledCountryCode = effectivePriorityCountryCode;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }

          final countryCode = effectivePriorityCountryCode;
          if (countryCode == null) {
            return;
          }

          final outerScrollable = Scrollable.maybeOf(context);
          if (outerScrollable == null) {
            return;
          }

          // Computes the absolute scroll offset that places the item just below
          // the sticky header. getOffsetToReveal is position-independent so no
          // rough-jump prerequisite is needed.
          double computeTarget(RenderBox ro) {
            final viewport = RenderAbstractViewport.of(ro);
            final hRO = stickyHeaderKey?.currentContext?.findRenderObject();
            final stickyHeight = hRO is RenderBox && hRO.attached ? hRO.size.height : 0.0;
            return (viewport.getOffsetToReveal(ro, 0).offset - stickyHeight)
                .clamp(0.0, outerScrollable.position.maxScrollExtent);
          }

          void applyScroll(RenderBox ro) {
            final target = computeTarget(ro);
            if (isDesktop) {
              outerScrollable.position.animateTo(
                target,
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOut,
              );
            } else {
              // Enable scrolling on the panel BEFORE jumpTo so the panel's
              // listener (which resets to 0 when !_scrollingEnabled) doesn't
              // fight us. This also lets the user scroll normally afterwards.
              final pc = homeState.panelController;
              if (pc.isAttached) {
                pc.enableScrolling();
              }
              outerScrollable.position.jumpTo(target);
            }
          }

          // Fast path: item is already in the widget tree.
          final itemCtx = _LocationKey(countryCode).currentContext;
          if (itemCtx != null) {
            final ro = itemCtx.findRenderObject() as RenderBox?;
            if (ro != null && ro.attached) {
              applyScroll(ro);
              return;
            }
          }

          // Slow path: item is off-screen (lazy list). Jump to a proportional
          // estimate so it gets built, then refine on the next frame.
          final pos = outerScrollable.position;
          final estimated = items.isEmpty
              ? 0.0
              : (pos.maxScrollExtent * priorityIndex / items.length)
                  .clamp(0.0, pos.maxScrollExtent);

          if (!isDesktop) {
            final pc = homeState.panelController;
            if (pc.isAttached) {
              pc.enableScrolling();
            }
          }
          pos.jumpTo(estimated);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            final refinedCtx = _LocationKey(countryCode).currentContext;
            if (refinedCtx == null) {
              return;
            }
            final ro = refinedCtx.findRenderObject() as RenderBox?;
            if (ro == null || !ro.attached) {
              return;
            }
            applyScroll(ro);
          });
        });

        return null;
      },
      [effectivePriorityCountryCode, isPanelFullyOpen],
    );

    return SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => LocationItem(
        key: scrollToSelected
            ? _LocationKey(items[index].countryCode)
            : ValueKey(items[index].countryCode),
        location: items[index],
        onTap: onItemPressed,
        userExpanded: userExpanded,
        userCollapsed: userCollapsed,
        mapSelectedCountryCode: effectivePriorityCountryCode,
      ),
    );
  }
}

// A GlobalKey that uniquely identifies a LocationItem by countryCode.
// Uses value-based equality so _LocationKey('CA').currentContext finds the
// registered element even when the String object is not identical.
class _LocationKey extends GlobalKey {
  const _LocationKey(this.countryCode) : super.constructor();
  final String countryCode;

  @override
  bool operator ==(Object other) => other is _LocationKey && other.countryCode == countryCode;

  @override
  int get hashCode => Object.hash(_LocationKey, countryCode);
}
