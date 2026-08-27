import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn/views/news_center/news_center_view.dart';
import 'package:mysterium_vpn/views/news_center/news_web_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';

/// Opens a tapped feed item. Injectable so widget tests can avoid launching a
/// real webview.
typedef NewsItemOpener = void Function(BuildContext context, NewscenterInboxListResponseItem item);

/// News Center feed, pushed on top of home via the `/main/news-center` route.
///
/// English-only (backend serves no translations for it), so it is forced
/// left-to-right regardless of the app locale. Mobile stacks the back bar above
/// the title; desktop puts the back control top-left with the title above a
/// centered, fixed-width content column.
class NewsCenterPage extends HookConsumerWidget {
  const NewsCenterPage({super.key, NewsItemOpener? onOpenItem, this.deepLinkItemId})
    : _onOpenItem = onOpenItem;

  final NewsItemOpener? _onOpenItem;

  /// Feed item id from a deep link (`/main/news-center?id=<id>`); when it
  /// resolves to a loaded item, that item is opened on entry — same as a tap.
  final int? deepLinkItemId;

  /// Fixed width of the feed column on desktop/tablet.
  static const desktopContentWidth = 426.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final store = ref.watch(newsCenterStorePOD);
    final openItem =
        _onOpenItem ??
        (ctx, item) =>
            showNewsItemWebView(ctx, item, userId: ref.read(authSessionStorePOD).user?.userId);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    void onItemTap(NewscenterInboxListResponseItem item) {
      ref
          .read(analyticsStorePOD)
          .logNewsCenterItemOpened(id: item.id.toInt(), category: item.category);
      store.markRead(item.id);
      openItem(context, item);
    }

    // Deep link: once the feed is loaded (awaiting a load still in flight), open
    // the item — same as a tap, so it is marked read and logged. No-ops when
    // there is no id or it isn't in the feed. Keyed on [deepLinkItemId] so a new
    // id re-triggers even when Beamer reuses this page's state for the route.
    useEffect(() {
      final id = deepLinkItemId;
      if (id == null) {
        return null;
      }
      // Guard against the id changing mid-load: the cleanup marks this run
      // stale so a slow `ensureLoaded` can't open the previous item.
      var cancelled = false;
      unawaited(() async {
        await store.ensureLoaded();
        if (cancelled || !context.mounted) {
          return;
        }
        final item = store.itemById(id);
        if (item != null) {
          onItemTap(item);
        } else if (!store.feedFetchFailed) {
          // The feed loaded but has no such item — tell the user. (A failed
          // fetch shows the page's own retry state instead, so we don't
          // misreport it as "expired".)
          showSnackbar(newsCenterItemUnavailableText, type: SnackbarType.info);
        }
      }());
      return () => cancelled = true;
    }, [deepLinkItemId]);

    void onBack() => _onBack(context, ref);

    final view = NewsCenterView(onItemTap: onItemTap);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        key: K.newsCenterPage,
        backgroundColor: theme.palette.bgSidePanel,
        body: SafeArea(
          child: isDesktop
              ? _DesktopLayout(view: view, onBack: onBack, store: store)
              : _MobileLayout(view: view, onBack: onBack, store: store),
        ),
      ),
    );
  }

  void _onBack(BuildContext context, WidgetRef ref) {
    ref.read(analyticsStorePOD).logNewsCenterBack();
    final beamer = Beamer.of(context);
    if (beamer.canBeamBack) {
      beamer.beamBack();
    }
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.view, required this.onBack, required this.store});

  final Widget view;
  final VoidCallback onBack;
  final NewsCenterStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Header(
          backgroundColor: theme.palette.bgSidePanel,
          showBackButton: true,
          backLabel: newsCenterBackText,
          onBackPressed: onBack,
        ),
        // Hidden while the full-screen loading/error state is showing so those
        // states center on the whole screen rather than below the title.
        Observer(
          builder: (_) => store.showsFullScreenState
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.fromLTRB(
                    theme.spacing.xl,
                    theme.spacing.s,
                    theme.spacing.xl,
                    theme.spacing.md,
                  ),
                  child: _NewsCenterTitle(),
                ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl),
            child: view,
          ),
        ),
      ],
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.view, required this.onBack, required this.store});

  final Widget view;
  final VoidCallback onBack;
  final NewsCenterStore store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Title + tabs + feed in a centered, fixed-width column.
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: NewsCenterPage.desktopContentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hidden during loading/error so those states center on-screen.
                Observer(
                  builder: (_) => store.showsFullScreenState
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: EdgeInsets.only(top: theme.spacing.md, bottom: theme.spacing.s),
                          child: _NewsCenterTitle(),
                        ),
                ),
                Expanded(child: view),
              ],
            ),
          ),
        ),
        // Back control pinned to the top-left, on the same row as the title.
        Positioned(
          top: theme.spacing.md,
          left: theme.spacing.xl,
          child: _DesktopBackButton(onPressed: onBack),
        ),
      ],
    );
  }
}

class _NewsCenterTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      newsCenterTitleText,
      style: theme.textStyles.displayXlg.semibold.copyWith(
        color: theme.palette.textPrimary,
        fontSize: 24,
        height: 28 / 24,
      ),
    );
  }
}

class _DesktopBackButton extends StatelessWidget {
  const _DesktopBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.all(theme.radius.s),
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.s),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: theme.spacing.s,
          children: [
            Icon(UntitledUI.arrow_left, size: 20, color: theme.palette.textPrimary),
            Text(
              newsCenterBackText,
              style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
