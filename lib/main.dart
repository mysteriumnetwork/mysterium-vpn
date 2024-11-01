import 'package:firebase_core/firebase_core.dart';
import 'package:mysterium_vpn/entrypoints/enviroment.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/models/flavor_config.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR');

  Enviroment().launch(
    flavor: flavor,
    isStoreVersion: _isStoreVersion(),
    firebaseOptions: _getFirebaseOptions(flavor),
  );
}

bool _isStoreVersion() {
  if (const bool.hasEnvironment('STORE')) {
    return const bool.fromEnvironment('STORE');
  }
  return true;
}

FirebaseOptions? _getFirebaseOptions(String flavor) {
  try {
    if (flavor == Flavor.dev.name) {
      return dev.DefaultFirebaseOptions.currentPlatform;
    } else {
      return prod.DefaultFirebaseOptions.currentPlatform;
    }
  } catch (_) {
    return null;
  }
}
