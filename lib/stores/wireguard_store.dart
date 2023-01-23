import 'package:mobx/mobx.dart';

// Include generated file
part 'wireguard_store.g.dart';

// ignore: library_private_types_in_public_api
class WireguardStore = _WireguardStore with _$WireguardStore;

abstract class _WireguardStore with Store {
  _WireguardStore(
      //{required this.wireguardService}
      );

  //final WireguardDart wireguardService;

  @observable
  ObservableFuture<void>? setupTunelFuture;

  @computed
  bool get hasResults => setupTunelFuture != null && setupTunelFuture?.status == FutureStatus.fulfilled;

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }

  Future<void> setupTunel() async {
    // setupTunelFuture = ObservableFuture(wireguardService.setupTunnel(bundleId: 'com.example.mysteriumVpn.'));
  }
}
