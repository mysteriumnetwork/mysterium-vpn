/// The active plan doesn't include the requested location. Surfaces the
/// upgrade flow instead of attempting a connect the backend would reject.
class PlanUpgradeRequiredException implements Exception {
  const PlanUpgradeRequiredException();
}
