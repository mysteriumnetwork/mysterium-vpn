import 'package:mysterium_vpn/entrypoints/enviroment.dart';
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_dev.dart' as dev;
import 'package:mysterium_vpn/entrypoints/firebase/firebase_options_prod.dart' as prod;
import 'package:mysterium_vpn/models/flavor_config.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR');
  Enviroment().launch(
    flavor: flavor,
    firebaseOptions: flavor == Flavor.dev.name
        ? dev.DefaultFirebaseOptions.currentPlatform
        : prod.DefaultFirebaseOptions.currentPlatform,
  );
}
