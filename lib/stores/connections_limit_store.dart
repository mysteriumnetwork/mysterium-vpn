import 'package:mobx/mobx.dart';

part 'connections_limit_store.g.dart';

// ignore: library_private_types_in_public_api
class ConnectionsLimitStore = _ConnectionsLimitStore with _$ConnectionsLimitStore;

abstract class _ConnectionsLimitStore with Store {
  _ConnectionsLimitStore();

  @observable
  bool connectionLimitReached = false;
}
