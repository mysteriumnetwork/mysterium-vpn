import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/news_center/components/news_center_empty_view.dart';
import 'package:mysterium_vpn/views/news_center/news_center_presentation.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vpn_api/vpn_api.dart';

/// Body of the News Center page: the filter tabs and the feed, with loading,
/// empty, error and data states. Pull-to-refresh is available wherever the
/// content scrolls.
class NewsCenterView extends HookConsumerWidget {
  const NewsCenterView({required this.onItemTap, super.key});

  /// Called when a card is tapped (marks read + opens the item).
  final void Function(NewscenterInboxListResponseItem item) onItemTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(newsCenterStorePOD);

    // Load/refresh whenever the page is entered; existing data is retained.
    useEffect(() {
      store.load();
      ref.read(analyticsStorePOD).logNewsCenterViewed();
      return null;
    }, const []);

    Future<void> onRefresh() async {
      ref.read(analyticsStorePOD).logNewsCenterRefreshed();
      final updated = await store.refresh();
      showSnackbar(
        updated ? newsCenterUpdatedText : newsCenterUpdateFailedText,
        type: updated ? SnackbarType.success : SnackbarType.error,
      );
    }

    void onRetry() {
      ref.read(analyticsStorePOD).logNewsCenterRetryClicked();
      store.refresh();
    }

    void onFilterSelected(NewsFilter filter) {
      ref.read(analyticsStorePOD).logNewsCenterFilterSelected(filter);
      store.selectedFilter = filter;
    }

    return Observer(
      builder: (context) {
        if (store.isInitialLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final theme = Theme.of(context);
        final hasError = store.hasError;
        final isEmpty = store.isEmpty ?? true;
        final items = store.filteredItems;
        // Read the clock once per build so all cards agree on "now" and we don't
        // re-read it per item.
        final now = DateTime.now();

        return RefreshIndicator.adaptive(
          onRefresh: onRefresh,
          displacement: 50,
          // A single scroll view with the tabs pinned inside it, so a pull from
          // anywhere — including over the tabs or empty space — triggers a
          // refresh, matching the locations list. AlwaysScrollable keeps the
          // pull working when the content doesn't fill the viewport.
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (!hasError)
                SliverPinnedHeader(
                  child: ColoredBox(
                    color: theme.palette.bgSidePanel,
                    child: _NewsFilterTabs(
                      selectedFilter: store.selectedFilter,
                      nonEmptyFilters: store.nonEmptyFilters,
                      onSelected: onFilterSelected,
                    ),
                  ),
                ),
              if (hasError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _NewsCenterErrorView(onRetry: onRetry),
                )
              else if (isEmpty)
                SliverLayoutBuilder(
                  builder: (context, sliverConstraints) => SliverToBoxAdapter(
                    child: NewsCenterEmptyView(
                      availableHeight: sliverConstraints.remainingPaintExtent,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(bottom: theme.spacing.xl),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => SizedBox(height: theme.spacing.md),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // Own Observer so the read-state read is tracked here (the
                      // itemBuilder runs lazily, outside the outer Observer's
                      // scope) — otherwise markRead wouldn't update the dot until
                      // the next rebuild.
                      return Observer(
                        builder: (context) => NewsCard(
                          categoryIcon: newsCategoryIcon(item.category),
                          categoryLabel: newsCategoryLabel(item.category),
                          title: item.title,
                          message: item.summary,
                          timeLabel: newsItemTimeLabel(item.createdAt, now: now),
                          unread: !store.isRead(item.id),
                          onTap: () => onItemTap(item),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NewsFilterTabs extends StatelessWidget {
  const _NewsFilterTabs({
    required this.selectedFilter,
    required this.nonEmptyFilters,
    required this.onSelected,
  });

  final NewsFilter selectedFilter;

  /// Filters with at least one item; the rest render disabled.
  final Set<NewsFilter> nonEmptyFilters;
  final void Function(NewsFilter filter) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const filters = NewsFilter.values;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
      child: NewsTabs(
        selectedIndex: filters.indexOf(selectedFilter),
        onSelected: (i) => onSelected(filters[i]),
        items: [
          for (final filter in filters)
            NewsTabItem(
              icon: newsFilterIcon(filter),
              label: newsFilterLabel(filter),
              enabled: nonEmptyFilters.contains(filter),
            ),
        ],
      ),
    );
  }
}

class _NewsCenterErrorView extends StatelessWidget {
  const _NewsCenterErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: ErrorRetryView(
      title: newsCenterErrorTitleText,
      message: newsCenterErrorSubtitleText,
      retryLabel: newsCenterRetryText,
      onRetry: onRetry,
    ),
  );
}
