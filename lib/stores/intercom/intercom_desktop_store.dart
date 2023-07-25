import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/stores/intercom/intercom_store.dart';

part 'intercom_desktop_store.g.dart';

// ignore: library_private_types_in_public_api
class IntercomDesktopStore = _IntercomDesktopStore with _$IntercomDesktopStore;

abstract class _IntercomDesktopStore extends IntercomStore with Store {
  _IntercomDesktopStore();

  @override
  @action
  Future<void> initialize() async {}

  @override
  @action
  Future<void> registerUser({
    String? email,
  }) async {}

  @override
  @action
  Future<void> logout() async {}

  @override
  @action
  Future<void> updateUser(
    String email,
    String userId,
  ) async {}

  @override
  @action
  Future<void> displayMessageComposer(String message) async {}

  @override
  @action
  Future<void> displayMessenger() async {}

  @override
  @action
  Future<void> displayHelpCenter() async {}
}
