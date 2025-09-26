import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/location.dart';

part 'selected_location_store.g.dart';

// ignore: library_private_types_in_public_api
class SelectedLocationStore = _SelectedLocationStore with _$SelectedLocationStore;

abstract class _SelectedLocationStore with Store {
  @observable
  VPNLocation? value;
}
