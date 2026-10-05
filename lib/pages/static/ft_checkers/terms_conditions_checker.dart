import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/url_launcher.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/terms_conditions_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

class _TermsConditionsPage extends ConsumerWidget {
  const _TermsConditionsPage({required this._termsConditionsStore});

  final TermsConditionsStore _termsConditionsStore;

  EdgeInsets get mobilePadding => const EdgeInsets.fromLTRB(16, 0, 16, 24);
  EdgeInsets get desktopPadding => const EdgeInsets.fromLTRB(180, 40, 180, 24);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Observer(
      builder: (context) {
        final failure = _termsConditionsStore.failure;

        return ColoredScaffold(
          backgroundColor: theme.palette.bgSidePanel,
          body: SafeArea(
            child: Padding(
              padding: isDesktop() ? desktopPadding : mobilePadding,
              child: Column(
                children: [
                  const _TermsConditionsHeader(),
                  if (failure == null)
                    Expanded(
                      child: _TermsConditionsContent(
                        isLoading: _termsConditionsStore.isLoading,
                        termsConditionsHtml:
                            _termsConditionsStore.latestTermsConditions?.content ?? '',
                        onAccept: _termsConditionsStore.acceptTermsConditions,
                      ),
                    ),
                  if (failure != null)
                    _TermsConditionsError(
                      failure: failure,
                      isLoading: _termsConditionsStore.isLoading,
                      onRetry: () => switch (failure) {
                        TermsConditionsFailureType.loading =>
                          _termsConditionsStore.checkForUpdatedTermsConditions(),
                        TermsConditionsFailureType.saving =>
                          _termsConditionsStore.acceptTermsConditions(),
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TermsConditionsContent extends HookWidget {
  const _TermsConditionsContent({
    required this._termsConditionsHtml,
    required this._onAccept,
    required this._isLoading,
  });

  final String _termsConditionsHtml;
  final VoidCallback _onAccept;
  final bool _isLoading;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(height: theme.spacing.xl2),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            scrollbarOrientation: ScrollbarOrientation.right,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Scrollbar(
                child: Container(
                  padding: EdgeInsets.all(theme.spacing.xl2),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.palette.borderPrimary),
                    borderRadius: BorderRadius.circular(theme.radius.xxxs.x),
                  ),
                  child: HtmlWidget(
                    _termsConditionsHtml,
                    textStyle: theme.textStyles.textSm.regular.copyWith(
                      color: theme.palette.textTertiary,
                    ),
                    onTapUrl: (url) =>
                        openUrlLink(Uri.parse(url), source: RedirectSource.termsOfService),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: theme.spacing.xl2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 343, minHeight: 44),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ButtonPrimary(
                  onPressed: _onAccept,
                  loading: _isLoading ? const ButtonLoading() : null,
                  // TODO(maz): localize
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ),
      ],
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
    return Column(
      children: [
        SizedBox(height: isDesktop() ? theme.spacing.xl7 : theme.spacing.xl6),
        AlertModal(
          icon: UntitledUI.alert_circle,
          screenType: ScreenType.mobile,
          type: AlertModalType.error,
          title: failure.title,
          supportingText: failure.content,
          backgroundColor: theme.palette.bgPrimary,
          borderColor: theme.palette.borderPrimary,
          primaryButton: Row(
            children: [
              ButtonTertiary(
                onPressed: onRetry,
                loading: isLoading ? const ButtonLoading() : null,
                decoration: const ButtonDecoration(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(S.current.retryBtn),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermsConditionsHeader extends StatelessWidget {
  const _TermsConditionsHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          minRadius: 24,
          backgroundColor: theme.palette.bgSecondarySelected,
          child: Icon(UntitledUI.check_circle, color: theme.palette.iconBrandSecondary, size: 32),
        ),
        SizedBox(height: theme.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                // TODO(maz): localize
                'Our Terms & Conditions have changed',
                textAlign: TextAlign.center,
                style: theme.textStyles.textLg.bold.copyWith(fontSize: 24),
              ),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                // TODO(maz): localize
                "We've updated our Terms & Conditions. Please review and accept the updated Terms to continue using Mysterium VPN.",
                textAlign: TextAlign.center,
                style: theme.textStyles.textMd.regular.copyWith(color: theme.palette.textTertiary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
