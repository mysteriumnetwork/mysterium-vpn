import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/in_app_message.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'in_app_messages_store.g.dart';

// ignore: library_private_types_in_public_api
class InAppMessagesStore = _InAppMessagesStore with _$InAppMessagesStore;

abstract class _InAppMessagesStore with Store {
  _InAppMessagesStore(
    this._remoteConfigStore,
  );

  final RemoteConfigStore _remoteConfigStore;

  @computed
  List<InAppMessage> get messages => _remoteConfigStore.inAppMessages;

  @computed
  InAppBanner? get activeBanner => messages.whereType<InAppBanner>().firstOrNull;
}
