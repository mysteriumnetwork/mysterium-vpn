import 'package:configcat_client/configcat_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_user_store.dart';

part 'config_cat_user_custom.freezed.dart';
part 'config_cat_user_custom.g.dart';

@freezed
abstract class ConfigCatUserCustom with _$ConfigCatUserCustom {
  const factory ConfigCatUserCustom({
    required String platform,
    required String version,
    required String? city,
    required String? subscriptionSource,
    required String? subscriptionPlan,
    required String? expirationDate,
    required String? subscriptionDuration,
    required String? recurring,
  }) = _ConfigCatUserCustom;

  const ConfigCatUserCustom._();

  factory ConfigCatUserCustom.fromJson(Map<String, dynamic> json) =>
      _$ConfigCatUserCustomFromJson(json);

  factory ConfigCatUserCustom.fromConfigCatUser(ConfigCatUser user) => ConfigCatUserCustom(
    platform: user.getAttributeOrNull<String>('platform')!,
    version: user.getAttributeOrNull<String>('version')!,
    city: user.getAttributeOrNull<String>('city'),
    subscriptionSource: user.getAttributeOrNull<String>('subscriptionSource'),
    subscriptionPlan: user.getAttributeOrNull<String>('subscriptionPlan'),
    expirationDate: user.getAttributeOrNull<String>('expirationDate'),
    subscriptionDuration: user.getAttributeOrNull<String>('subscriptionDuration'),
    recurring: user.getAttributeOrNull<String>('recurring'),
  );

  Map<String, String> toAttributes() {
    final json = toJson();
    return {
      for (final entry in json.entries)
        if (entry.value != null) entry.key: entry.value.toString(),
    };
  }
}
