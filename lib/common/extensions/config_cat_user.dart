import 'package:configcat_client/configcat_client.dart';

/// Typed attribute access, split out of `ConfigCatUserStore` so models can use
/// it without importing the store layer.
extension ConfigCatUserAttributes on ConfigCatUser {
  /// The attribute at [key] when it is a [T], otherwise null.
  T? getAttributeOrNull<T>(String key) {
    final value = getAttribute(key);
    return value is T ? value : null;
  }
}
