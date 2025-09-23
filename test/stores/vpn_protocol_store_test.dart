import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/vpn_protocol_store.dart';

import 'vpn_protocol_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalDBService>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  late MockLocalDBService mockLocalDB;
  late MockAnalyticsStore mockAnalyticsStore;
  late VpnProtocolStore store;

  setUp(() {
    mockLocalDB = MockLocalDBService();
    mockAnalyticsStore = MockAnalyticsStore();
    store = VpnProtocolStore(mockLocalDB, mockAnalyticsStore);
  });

  group('getProtocol', () {
    test('loads protocol from local DB and sets observable', () async {
      when(mockLocalDB.getProtocolType()).thenAnswer((_) async => ProtocolType.openvpn);

      final protocol = await store.getProtocol();

      expect(protocol, ProtocolType.openvpn);
      expect(store.protocol, ProtocolType.openvpn);
    });

    test('throws on error', () async {
      when(mockLocalDB.getProtocolType()).thenThrow(Exception('fail'));

      expect(() => store.getProtocol(), throwsException);
    });
  });

  group('setProtocol', () {
    test('sets protocol, saves to local DB, and logs analytics', () async {
      when(mockLocalDB.setProtocolType(ProtocolType.openvpn)).thenAnswer((_) async => {});

      await store.setProtocol(ProtocolType.openvpn);

      expect(store.protocol, ProtocolType.openvpn);
      verify(mockLocalDB.setProtocolType(ProtocolType.openvpn)).called(1);
      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.changeProtocolType,
          parameters: {'protocol': 'openvpn'},
        ),
      ).called(1);
    });

    test('logs analytics error on failure', () async {
      when(mockLocalDB.setProtocolType(ProtocolType.openvpn)).thenThrow(Exception('fail'));

      expect(() => store.setProtocol(ProtocolType.openvpn), throwsException);

      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.changeProtocolTypeError,
          parameters: {
            'error': contains('fail'),
            'protocol': 'openvpn',
          },
        ),
      ).called(1);
    });
  });
}
