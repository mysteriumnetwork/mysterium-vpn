import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

void main() {
  test('value defaults to null and is settable', () {
    final store = SelectedLocationStore();

    expect(store.value, isNull);

    const location = VPNLocation(
      id: 'us',
      ipType: IPType.residential,
      countryCode: 'US',
      translations: {},
    );
    store.value = location;
    expect(store.value, location);
  });
}
