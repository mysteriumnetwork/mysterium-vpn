import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:storekit_extensions/storekit_extensions_android.dart';
import 'package:storekit_extensions/storekit_extensions_windows.dart';

import 'storekit_extensions_darwin.dart';

abstract class StorekitExtensionsPlatform extends PlatformInterface {
  /// Constructs a StorekitExtensionsPlatform.
  StorekitExtensionsPlatform() : super(token: _token);

  static final Object _token = Object();

  static StorekitExtensionsPlatform _instance = _getInstance();

  /// The default instance of [StorekitExtensionsPlatform] to use.
  ///
  /// Defaults to [MethodChannelStorekitExtensions].
  static StorekitExtensionsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StorekitExtensionsPlatform] when
  /// they register themselves.
  static set instance(StorekitExtensionsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> isEligibleForIntroOffer(String productId) {
    throw UnimplementedError('isEligibleForIntroOffer() has not been implemented.');
  }
}

StorekitExtensionsPlatform _getInstance() {
  if (Platform.isIOS || Platform.isMacOS) {
    return StorekitExtensionsDarwin();
  }
  if (Platform.isAndroid) {
    return StoreKitExtensionsAndroid();
  }
  if (Platform.isWindows) {
    return StoreKitExtensionsWindows();
  }

  throw UnsupportedError('Platform ${Platform.operatingSystem} is not supported');
}
