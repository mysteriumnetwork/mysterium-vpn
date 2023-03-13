import 'package:mysterium_vpn/enviroment.dart';
import 'package:mysterium_vpn/firebase_options_prod.dart';
import 'package:mysterium_vpn/flavor_config.dart';

void main() async {
  Enviroment().launch(
    env: FlavorConfig(
      flavor: Flavor.production,
      values: FlavorValues.production(),
    ),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
