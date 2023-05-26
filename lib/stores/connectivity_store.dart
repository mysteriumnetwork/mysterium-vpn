import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

part 'connectivity_store.g.dart';

// ignore: library_private_types_in_public_api
class ConnectivityStore = _ConnectivityStore with _$ConnectivityStore;

abstract class _ConnectivityStore with Store {
  _ConnectivityStore() {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @readonly
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  @observable
  bool isInitState = true;

  Timer? _debounce;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(seconds: 4), () {
      _connectionStatus = result;
      //handleConectivityStatusChanged(result);
    });
  }

  void handleConectivityStatusChanged(
    ConnectivityResult connectivityStatus,
  ) {
    connectivityStatus == ConnectivityResult.none
        ? showSnackbar(LocaleKeys.currentlyOffline.tr())
        : showSnackbar(LocaleKeys.internetConnectionRestored.tr(), type: MessageType.success);
  }
}
