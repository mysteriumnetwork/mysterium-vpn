import 'package:mobx/mobx.dart';

abstract class IntercomStore {
  Future<void> initialize();

  Future<void> registerUser({
    String? email,
  });

  Future<void> logout();

  Future<void> updateUser(
    String email,
    String userId,
  );

  Future<void> displayMessageComposer(String message);

  @action
  Future<void> displayMessenger();

  @action
  Future<void> displayHelpCenter();
}
