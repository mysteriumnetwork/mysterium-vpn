import 'package:mobx/mobx.dart';

part 'terms_conditions_store.g.dart';

// ignore: library_private_types_in_public_api
class TermsConditionsStore = _TermsConditionsStore with _$TermsConditionsStore;

abstract class _TermsConditionsStore with Store {
  @observable
  bool needsTermsConditionsApproval = false;

  @action
  Future<void> checkForUpdatedTermsConditions() async {}
}
