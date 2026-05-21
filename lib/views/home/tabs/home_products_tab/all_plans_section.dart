part of 'home_products_tab.dart';

class _AllPlansSection extends StatelessWidget {
  const _AllPlansSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.productsAllPlansLbl.tr(),
          style: theme.textStyles.textMd.medium.copyWith(color: theme.palette.textTertiary),
        ),
        SizedBox(height: theme.spacing.ms),
        Wrap(
          spacing: theme.spacing.xs,
          runSpacing: theme.spacing.xs,
          children: [
            AppBadge(text: LocaleKeys.productsDuration1Month.tr(), size: BadgeSize.small),
            AppBadge(text: LocaleKeys.productsDuration1Year.tr(), size: BadgeSize.small),
            AppBadge(text: LocaleKeys.productsDuration2Year.tr(), size: BadgeSize.small),
          ],
        ),
        SizedBox(height: theme.spacing.ms),
        _PlanTierCard(
          icon: UntitledUI.star_04,
          name: LocaleKeys.subscriptionPlanNameBasic.tr(),
          description: LocaleKeys.productsBasicDescription.tr(),
        ),
        SizedBox(height: theme.spacing.s),
        _PlanTierCard(
          icon: UntitledUI.stars_02,
          name: LocaleKeys.subscriptionPlanNamePlus.tr(),
          description: LocaleKeys.productsPlusDescription.tr(),
        ),
        SizedBox(height: theme.spacing.s),
        _PlanTierCard(
          icon: UntitledUI.stars_03,
          name: LocaleKeys.subscriptionPlanNamePro.tr(),
          description: LocaleKeys.productsProDescription.tr(),
        ),
      ],
    );
  }
}

class _PlanTierCard extends StatelessWidget {
  const _PlanTierCard({required this.icon, required this.name, required this.description});

  final IconData icon;
  final String name;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.ms, vertical: theme.spacing.lg),
      decoration: BoxDecoration(
        color: theme.palette.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.palette.borderPrimary),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.palette.bgSecondarySelected,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, size: 16, color: theme.palette.textBrandPrimary),
          ),
          SizedBox(width: theme.spacing.s),
          Text(
            name,
            style: theme.textStyles.textMd.bold.copyWith(color: theme.palette.textPrimary),
          ),
          SizedBox(width: theme.spacing.s),
          Expanded(
            child: Text(
              description,
              style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textTertiary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
