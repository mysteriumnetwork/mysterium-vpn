part of 'home_products_tab.dart';

class _MaxPlanView extends StatelessWidget {
  const _MaxPlanView();

  @override
  Widget build(BuildContext context) => _ProductsBrowsingView(
    subtitle: S.current.productsExploreSubtitle,
    alertMessage: S.current.productsMaxPlanAlert,
  );
}
