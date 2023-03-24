import 'package:mysterium_vpn/entrypoints/enviroment.dart';
import 'package:mysterium_vpn/firebase_options.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'PROD');
  Enviroment().launch(
    flavor: flavor,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
