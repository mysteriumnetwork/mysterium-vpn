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
          S.current.productsAllPlansLbl,
          style: theme.textStyles.textMd.medium.copyWith(color: theme.palette.textTertiary),
        ),
        SizedBox(height: theme.spacing.ms),
        Wrap(
          spacing: theme.spacing.xs,
          runSpacing: theme.spacing.xs,
          children: [
            AppBadge(text: S.current.productsDuration1Month, size: BadgeSize.small),
            AppBadge(text: S.current.productsDuration1Year, size: BadgeSize.small),
            AppBadge(text: S.current.productsDuration2Year, size: BadgeSize.small),
          ],
        ),
        SizedBox(height: theme.spacing.ms),
        _PlanTierCard(
          icon: UntitledUI.star_04,
          name: S.current.subscriptionPlanNameBasic,
          description: S.current.productsBasicDescription,
        ),
        SizedBox(height: theme.spacing.s),
        _PlanTierCard(
          icon: UntitledUI.stars_02,
          name: S.current.subscriptionPlanNamePlus,
          description: S.current.productsPlusDescription,
        ),
        SizedBox(height: theme.spacing.s),
        _PlanTierCard(
          icon: UntitledUI.stars_03,
          name: S.current.subscriptionPlanNamePro,
          description: S.current.productsProDescription,
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
        borderRadius: const BorderRadius.all(Radius.kS),
        border: Border.all(color: theme.palette.borderPrimary),
      ),
      child: Row(
        children: [
          DecoratedIcon(
            icon: icon,
            decoration: IconDecoration(
              backgroundColor: theme.palette.bgSecondarySelected,
              iconColor: theme.palette.textBrandPrimary,
              padding: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.kXxxs),
            ),
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
