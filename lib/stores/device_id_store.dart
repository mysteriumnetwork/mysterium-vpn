import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';

part 'device_id_store.g.dart';

// ignore: library_private_types_in_public_api
class DeviceIDStore = _DeviceIDStore with _$DeviceIDStore;

abstract class _DeviceIDStore with Store {
  _DeviceIDStore({required DeviceIdRepository repository}) : _repository = repository {
    deviceIdFuture = ObservableFuture(_repository.getDeviceId());
  }

  final DeviceIdRepository _repository;

  @observable
  late ObservableFuture<String> deviceIdFuture;

  @computed
  String get deviceId => deviceIdFuture.value ?? '';
}
