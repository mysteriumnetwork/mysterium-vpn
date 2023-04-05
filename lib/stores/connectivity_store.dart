import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobx/mobx.dart';

part 'connectivity_store.g.dart';

// ignore: library_private_types_in_public_api
class ConnectivityStore = _ConnectivityStore with _$ConnectivityStore;

abstract class _ConnectivityStore with Store {
  _ConnectivityStore() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @readonly
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  @readonly
  ConnectivityResult _prevConnectionStatus = ConnectivityResult.none;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _prevConnectionStatus = _connectionStatus;
    _connectionStatus = result;
  }
}
