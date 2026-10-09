import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/url_launcher.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/terms_conditions_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Blocks the app until the user accepts terms the backend flags as pending.
class TermsConditionsChecker extends HookConsumerWidget {
  const TermsConditionsChecker({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsConditionsStore = ref.watch(termsConditionsStorePOD);

    return Observer(
      builder: (context) => termsConditionsStore.requiresTermsConditionsApproval
          ? _TermsConditionsPage(termsConditionsStore: termsConditionsStore)
          : child,
    );
  }
}

class _TermsConditionsPage extends StatelessWidget {
  const _TermsConditionsPage({required this._termsConditionsStore});

  final TermsConditionsStore _termsConditionsStore;

  /// Content width on the desktop frame; the mobile frame is narrower than
  /// this, so it just falls back to the full width minus the side gutter.
  static const _maxContentWidth = 680.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = ScreenType.of(context) >= ScreenType.tablet;
    final insets = EdgeInsets.fromLTRB(
      theme.spacing.md,
      isWide ? theme.spacing.xl4 : 0,
      theme.spacing.md,
      0,
    );

    Widget constrain(Widget child) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxContentWidth),
        child: child,
      ),
    );

    return Observer(
      builder: (context) {
        final failure = _termsConditionsStore.failure;

        return ColoredScaffold(
          backgroundColor: theme.palette.bgSidePanel,
          body: failure != null
              ? _failureBody(failure, insets, constrain)
              : _documentBody(theme, insets, constrain, isWide: isWide),
        );
      },
    );
  }

  /// The alert is centred on the page, not below the header.
  Widget _failureBody(
    TermsConditionsFailureType failure,
    EdgeInsets insets,
    Widget Function(Widget) constrain,
  ) {
    // Retry reruns whichever call failed.
    final (isRetrying, onRetry) = switch (failure) {
      TermsConditionsFailureType.loading => (
        _termsConditionsStore.isLoading,
        _termsConditionsStore.checkForUpdatedTermsConditions,
      ),
      TermsConditionsFailureType.saving => (
        _termsConditionsStore.isAccepting,
        _termsConditionsStore.acceptTermsConditions,
      ),
    };

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(padding: insets, child: constrain(const _TermsConditionsHeader())),
        ),
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: insets.copyWith(top: 0),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: constrain(
                    _TermsConditionsError(
                      failure: failure,
                      isLoading: isRetrying,
                      onRetry: onRetry,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _documentBody(
    ThemeData theme,
    EdgeInsets insets,
    Widget Function(Widget) constrain, {
    required bool isWide,
  }) => Column(
    children: [
      Expanded(
        child: Padding(
          padding: insets,
          child: constrain(
            Column(
              // Without this the panel shrink-wraps its content and collapses
              // while the terms are still loading.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _TermsConditionsHeader(),
                SizedBox(height: theme.spacing.xl2),
                Expanded(
                  child: Observer(
                    builder: (context) => _TermsConditionsDocument(
                      termsConditionsHtml: _termsConditionsStore.latestTermsConditions?.content,
                      isWide: isWide,
                    ),
                  ),
                ),
                SizedBox(height: theme.spacing.s),
              ],
            ),
          ),
        ),
      ),
      // Own Observer so the transient loading flags do not rebuild the
      // document and re-run HtmlWidget's async build.
      Observer(
        builder: (context) => _TermsConditionsAcceptBar(
          hasContent: _termsConditionsStore.latestTermsConditions != null,
          isChecking: _termsConditionsStore.isLoading,
          isAccepting: _termsConditionsStore.isAccepting,
          onAccept: _termsConditionsStore.acceptTermsConditions,
        ),
      ),
    ],
  );
}

class _TermsConditionsHeader extends StatelessWidget {
  const _TermsConditionsHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedIcon(
          icon: UntitledUI.check_circle,
          decoration: IconDecoration(
            iconSize: 32,
            iconColor: theme.palette.iconBrandSecondary,
            backgroundColor: theme.palette.bgSecondarySelected,
            padding: EdgeInsets.all(theme.spacing.s),
            borderRadius: const BorderRadius.all(Radius.kFull),
          ),
        ),
        SizedBox(height: theme.spacing.md),
        Text(
          S.current.termsConditionsUpdatedTitle,
          textAlign: TextAlign.center,
          // No 24/28 scale in the design system yet.
          style: theme.textStyles.textLg.bold.copyWith(
            fontSize: 24,
            height: 28 / 24,
            color: theme.palette.textPrimary,
          ),
        ),
        SizedBox(height: theme.spacing.md),
        Text(
          S.current.termsConditionsUpdatedSubtitle,
          textAlign: TextAlign.center,
          style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textTertiary),
        ),
      ],
    );
  }
}

class _TermsConditionsDocument extends HookWidget {
  const _TermsConditionsDocument({required this.termsConditionsHtml, required this.isWide});

  /// Null until the terms have been fetched.
  final String? termsConditionsHtml;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final theme = Theme.of(context);
    final html = termsConditionsHtml;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.palette.bgPrimary,
        border: Border.all(color: theme.palette.borderPrimary),
        borderRadius: BorderRadius.all(theme.radius.xxxs),
      ),
      child: html == null
          ? Center(child: LoadingIndicator.message(S.current.termsConditionsLoading))
          : Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.right,
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.all(isWide ? theme.spacing.xl2 : theme.spacing.md),
                child: HtmlWidget(
                  html,
                  textStyle: theme.textStyles.textMd.regular.copyWith(
                    color: theme.palette.textTertiary,
                  ),
                  onTapUrl: (url) =>
                      openUrlLink(Uri.parse(url), source: RedirectSource.termsOfService),
                ),
              ),
            ),
    );
  }
}

class _TermsConditionsAcceptBar extends StatelessWidget {
  const _TermsConditionsAcceptBar({
    required this.hasContent,
    required this.isChecking,
    required this.isAccepting,
    required this.onAccept,
  });

  /// False only before the first successful fetch.
  final bool hasContent;

  /// A consent re-check is in flight — on resume the terms are already on
  /// screen, so this is a refresh rather than a first load.
  final bool isChecking;
  final bool isAccepting;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loadingText = switch (null) {
      _ when isAccepting => S.current.termsConditionsAcceptingBtn,
      _ when !hasContent => S.current.termsConditionsLoadingBtn,
      _ when isChecking => S.current.termsConditionsCheckingBtn,
      _ => null,
    };
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.palette.bgSidePanel,
        border: Border(top: BorderSide(color: theme.palette.borderPrimary)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            theme.spacing.md,
            theme.spacing.md,
            theme.spacing.md,
            theme.spacing.xl2,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 343),
              child: SizedBox(
                width: double.infinity,
                child: ButtonPrimary(
                  // Disabled, not just tap-swallowed, while there is nothing to
                  // accept. Accepting keeps the brand fill per the design.
                  onPressed: hasContent && !isChecking ? onAccept : null,
                  loading: loadingText == null ? null : ButtonLoading(text: loadingText),
                  child: Text(S.current.termsConditionsAcceptBtn),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TermsConditionsError extends StatelessWidget {
  const _TermsConditionsError({
    required this.failure,
    required this.onRetry,
    required this.isLoading,
  });

  final TermsConditionsFailureType failure;
  final VoidCallback onRetry;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (title, content) = switch (failure) {
      TermsConditionsFailureType.saving => (
        S.current.termsConditionsSaveFailureTitle,
        S.current.termsConditionsSaveFailureContent,
      ),
      TermsConditionsFailureType.loading => (
        S.current.termsConditionsLoadFailureTitle,
        S.current.termsConditionsLoadFailureContent,
      ),
    };
    return AlertModal(
      icon: UntitledUI.alert_circle,
      // The design stacks the badge above the text on desktop too.
      screenType: ScreenType.mobile,
      type: AlertModalType.error,
      title: title,
      supportingText: content,
      backgroundColor: theme.palette.bgPrimary,
      borderColor: theme.palette.borderPrimary,
      primaryButton: ButtonTertiary(
        onPressed: onRetry,
        loading: isLoading ? const ButtonLoading() : null,
        decoration: const ButtonDecoration(padding: EdgeInsets.zero, minimumSize: Size.zero),
        child: Text(S.current.retryBtn),
      ),
    );
  }
}
