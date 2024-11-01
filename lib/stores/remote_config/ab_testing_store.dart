import 'package:configcat_client/configcat_client.dart';
import 'package:mobx/mobx.dart';
import 'package:talker/talker.dart';

part 'ab_testing_store.g.dart';

enum _ABKey {
  subscriptionFlow,
}

class ABTestingStore = ABTestingStoreBase with _$ABTestingStore;

abstract class ABTestingStoreBase with Store {
  ABTestingStoreBase({
    required this.client,
    required this.logger,
  }) {
    getAllABTestingValues();
  }
  final ConfigCatClient client;
  final Talker logger;

  @observable
  ObservableMap<String, dynamic> config = ObservableMap();

  @action
  Future<void> setDefaultUser({
    required String email,
    required String userId,
  }) async {
    client.setDefaultUser(
      ConfigCatUser(
        identifier: userId,
        email: email,
      ),
    );
  }

  @action
  Future<void> getAllABTestingValues() async {
    try {
      config = ObservableMap.of(await client.getAllValues());
    } catch (e, st) {
      logger.handle(e, st);
      config = ObservableMap();
    } finally {
      refreshABTestingValues();
    }
  }

  @action
  Future<void> refreshABTestingValues() async {
    client.hooks.addOnConfigChanged((flags) async {
      config = ObservableMap.of(await client.getAllValues());
    });
  }

  @computed
  String get subscriptionFlow {
    if (config.containsKey(_ABKey.subscriptionFlow.name)) {
      return config[_ABKey.subscriptionFlow.name] as String;
    }
    return 'A';
  }
}
