part of 'home_products_tab.dart';

/// Shared layout for the read-only "browse plans" variants of the Products
/// tab — the manage-on-web state and the max-plan state. Differs only in the
/// subtitle, info-alert text, and the optional bottom [action] button.
class _ProductsBrowsingView extends StatelessWidget {
  const _ProductsBrowsingView({required this.subtitle, required this.alertMessage, this.action});

  final String subtitle;
  final String alertMessage;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final hPad = isDesktop ? theme.spacing.xl3 : theme.spacing.md;

    return SafeArea(
      child: BackgroundGradient(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: theme.spacing.xl4),
                        const Center(
                          child: DecoratedIcon(
                            icon: UntitledUI.stars_02,
                            decoration: IconDecoration(iconSize: 24),
                          ),
                        ),
                        SizedBox(height: theme.spacing.ms),
                        Text(
                          LocaleKeys.productsTitle.tr(),
                          textAlign: TextAlign.center,
                          style: theme.textStyles.displayXlg.bold.copyWith(
                            color: theme.palette.textPrimary,
                          ),
                        ),
                        SizedBox(height: theme.spacing.s),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: theme.textStyles.textMd.regular.copyWith(
                            color: theme.palette.textSecondary,
                          ),
                        ),
                        SizedBox(height: theme.spacing.xl2),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPad),
                          child: MinimalAlert(
                            message: alertMessage,
                            leadingIcon: UntitledUI.info_circle,
                          ),
                        ),
                        SizedBox(height: theme.spacing.xl2),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: hPad),
                          child: const _AllPlansSection(),
                        ),
                        if (action != null && isDesktop) ...[
                          SizedBox(height: theme.spacing.xl2),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            child: Center(child: action),
                          ),
                        ],
                        SizedBox(height: theme.spacing.xl2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (action != null && !isDesktop)
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, theme.spacing.md, hPad, theme.spacing.md),
                child: action,
              ),
          ],
        ),
      ),
    );
  }
}
