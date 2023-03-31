import 'package:mysterium_vpn/entrypoints/enviroment.dart';

void main() async {
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'DEV');
  Enviroment().launch(
    flavor: flavor,
  );
}
