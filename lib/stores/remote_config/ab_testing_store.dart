import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'ab_testing_store.g.dart';

enum _ABKey { reviewDestination }

class ABTestingStore = ABTestingStoreBase with _$ABTestingStore;

abstract class ABTestingStoreBase extends ConfigCatStore with Store {
  ABTestingStoreBase(super.client, super.logger, this._analytics) {
    reaction((_) => configFuture, (future) async {
      await future;
      asUserProperties.forEach((key, value) async {
        await _analytics.setUserProperty(AnalyticsUserProperty.fromString(name: key, value: value));
      });
    }, fireImmediately: true);
  }

  final AnalyticsStore _analytics;

  /// Which destination the review prompt's "Leave a review" button opens.
  /// Falls back to [ReviewDestination.store] when the variant is absent or not
  /// a string, so a malformed flag can never strand users without a review path.
  ReviewDestination get reviewDestination =>
      ReviewDestination.fromName(config[_ABKey.reviewDestination.name]?.toString());

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry('group_${key.toSnakeCase}', value.toString()));
}
