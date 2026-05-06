import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  test('getCoordinates parses the bundled JSON into a {country: LatLng} map', () async {
    // Substitute the asset payload with deterministic data.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async => ByteData.sublistView(
        Uint8List.fromList(
          '{"US": {"latitude": 37.0902, "longitude": -95.7129}, '
                  '"DE": {"latitude": 51.1657, "longitude": 10.4515}}'
              .codeUnits,
        ),
      ),
    );

    const service = AssetsService();
    final coords = await service.getCoordinates();

    expect(coords.keys.toSet(), {'US', 'DE'});
    expect(coords['US']!.latitude, closeTo(37.0902, 0.001));
    expect(coords['US']!.longitude, closeTo(-95.7129, 0.001));
    expect(coords['DE']!.latitude, closeTo(51.1657, 0.001));
  });
}
