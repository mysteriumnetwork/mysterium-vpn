import 'package:mysterium_vpn/enviroment.dart';
import 'package:mysterium_vpn/firebase_options_dev.dart';
import 'package:mysterium_vpn/flavor_config.dart';

void main() async {
  Enviroment().launch(
    env: FlavorConfig(
      flavor: Flavor.dev,
      values: FlavorValues.dev(),
    ),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
