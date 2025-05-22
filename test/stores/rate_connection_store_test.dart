import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/rate_connection_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:wireguard_dart/key_pair.dart';

import 'rate_connection_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AnalyticsStore>(),
  MockSpec<ApiService>(),
  MockSpec<VpnStore>(),
  MockSpec<VpnConnection>(),
  MockSpec<KeyPair>(),
])
void main() {
  late RateConnectionStore store;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockApiService mockApiService;
  late MockVpnStore mockVpnStore;

  setUp(() {
    mockAnalyticsStore = MockAnalyticsStore();
    mockApiService = MockApiService();
    mockVpnStore = MockVpnStore();
    store = RateConnectionStore(mockAnalyticsStore, mockApiService, mockVpnStore);
  });

  group('RateConnectionStore', () {
    test('reset clears all fields', () {
      store
        ..feedback = 'test'
        ..setRateConnectionMode(RateConnectionRequestModeEnum.like)
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first)
        ..reset();

      expect(store.feedback, '');
      expect(store.selectedReasons, isEmpty);
      expect(store.isLikeMode, isFalse);
      expect(store.isDislikeMode, isFalse);
      expect(store.submitRateConnectionFuture, isNull);
    });

    test('setRateConnectionMode sets mode and clears reasons', () {
      store
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first)
        ..setRateConnectionMode(RateConnectionRequestModeEnum.dislike);

      expect(store.isDislikeMode, isTrue);
      expect(store.selectedReasons, isEmpty);
      verify(mockAnalyticsStore.logRateConnnectionClicked(RateConnectionRequestModeEnum.dislike))
          .called(1);
    });

    test('toggleRateConnectionReason adds and removes reasons', () {
      final reason = RateConnectionReason.dislikeReasons.first;
      store
        ..setRateConnectionMode(RateConnectionRequestModeEnum.dislike)
        ..toggleRateConnectionReason(reason);
      expect(store.selectedReasons, contains(reason));

      store.toggleRateConnectionReason(reason);
      expect(store.selectedReasons, isNot(contains(reason)));
    });

    test('showReasons returns correct reasons for mode', () {
      store.setRateConnectionMode(RateConnectionRequestModeEnum.like);
      expect(store.showReasons, RateConnectionReason.likeReasons);

      store.setRateConnectionMode(RateConnectionRequestModeEnum.dislike);
      expect(store.showReasons, RateConnectionReason.dislikeReasons);
    });

    test('submitRateConnection does nothing if mode or vpnConnection is null', () async {
      await store.submitRateConnection();
      verifyNever(mockAnalyticsStore.logEvent(any));
      verifyNever(mockApiService.rateConnection(request: anyNamed('request')));
    });

    test('submitRateConnection calls api and logs analytics', () async {
      // Arrange
      store
        ..setRateConnectionMode(RateConnectionRequestModeEnum.like)
        ..feedback = 'Great connection!'
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first);

      final mockVpnConnection = MockVpnConnection();
      final mockKeyPair = MockKeyPair();
      when(mockVpnStore.vpnConnection).thenReturn(mockVpnConnection);
      when(mockVpnStore.wireguardKey).thenReturn(mockKeyPair);
      when(mockKeyPair.publicKey).thenReturn('pubkey');
      when(mockVpnConnection.location).thenReturn(
        const VPNLocation(code: 'US'),
      );
      when(
        mockApiService.rateConnection(
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await store.submitRateConnection();

      // Assert
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmit)).called(1);
      verify(
        mockApiService.rateConnection(
          request: argThat(
            isA<RateConnectionRequest>()
                .having((r) => r.mode, 'mode', RateConnectionRequestModeEnum.like)
                .having(
                  (r) => r.reasons,
                  'reasons',
                  RateConnectionReason.likeReasons.first.toString(),
                )
                .having((r) => r.feedback, 'feedback', 'Great connection!')
                .having((r) => r.country, 'country', 'US')
                .having((r) => r.ipType, 'ipType', 'residential')
                .having((r) => r.publicKey, 'publicKey', 'pubkey'),
            named: 'request',
          ),
        ),
      ).called(1);
      expect(store.submitRateConnectionFuture, isNotNull);
    });

    test('submitRateConnection calls api and logs analytics no reasons', () async {
      // Arrange
      store
        ..setRateConnectionMode(RateConnectionRequestModeEnum.like)
        ..feedback = 'Great connection!';

      final mockVpnConnection = MockVpnConnection();
      final mockKeyPair = MockKeyPair();
      when(mockVpnStore.vpnConnection).thenReturn(mockVpnConnection);
      when(mockVpnStore.wireguardKey).thenReturn(mockKeyPair);
      when(mockKeyPair.publicKey).thenReturn('pubkey');
      when(mockVpnConnection.location).thenReturn(
        const VPNLocation(code: 'US'),
      );
      when(
        mockApiService.rateConnection(
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await store.submitRateConnection();

      // Assert
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmit)).called(1);
      verify(
        mockApiService.rateConnection(
          request: argThat(
            isA<RateConnectionRequest>()
                .having((r) => r.mode, 'mode', RateConnectionRequestModeEnum.like)
                .having(
                  (r) => r.reasons,
                  'reasons',
                  RateConnectionReason.other.name,
                )
                .having((r) => r.feedback, 'feedback', 'Great connection!')
                .having((r) => r.country, 'country', 'US')
                .having((r) => r.ipType, 'ipType', 'residential')
                .having((r) => r.publicKey, 'publicKey', 'pubkey'),
            named: 'request',
          ),
        ),
      ).called(1);
      expect(store.submitRateConnectionFuture, isNotNull);
    });

    test('submitRateConnection completes with error if api throws', () async {
      // Arrange
      store
        ..setRateConnectionMode(RateConnectionRequestModeEnum.like)
        ..feedback = 'Great connection!'
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first);

      final mockVpnConnection = MockVpnConnection();
      final mockKeyPair = MockKeyPair();
      when(mockVpnStore.vpnConnection).thenReturn(mockVpnConnection);
      when(mockVpnStore.wireguardKey).thenReturn(mockKeyPair);
      when(mockKeyPair.publicKey).thenReturn('pubkey');
      when(mockVpnConnection.location).thenReturn(
        const VPNLocation(code: 'US'),
      );
      when(
        mockApiService.rateConnection(
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => throw Exception('API error'));

      // Act & Assert
      await expectLater(store.submitRateConnection(), throwsA(isA<Exception>()));
      expect(store.submitRateConnectionFuture, isNotNull);
      await expectLater(store.submitRateConnectionFuture, throwsA(isA<Exception>()));
    });

    test('cancelRateConnection logs analytics if mode is set', () {
      store
        ..setRateConnectionMode(RateConnectionRequestModeEnum.like)
        ..cancelRateConnection();
      verify(mockAnalyticsStore.logRateConnectionCancel(RateConnectionRequestModeEnum.like))
          .called(1);
    });

    test('cancelRateConnection does nothing if mode is null', () {
      store.cancelRateConnection();
      verifyNever(mockAnalyticsStore.logRateConnectionCancel(any));
    });
  });
}
