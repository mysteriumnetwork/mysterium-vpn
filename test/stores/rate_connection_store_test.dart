import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/rate_connection.dart';
import 'package:mysterium_vpn/common/utils/mocks.dart';
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
  late RateConnectionStore likeModeStore;
  late RateConnectionStore dislikeModeStore;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockApiService mockApiService;
  late MockVpnStore mockVpnStore;

  setUp(() {
    mockAnalyticsStore = MockAnalyticsStore();
    mockApiService = MockApiService();
    mockVpnStore = MockVpnStore();
    likeModeStore = RateConnectionStore(
      RateConnectionRequestModeEnum.like,
      mockAnalyticsStore,
      mockApiService,
      mockVpnStore,
    );
    dislikeModeStore = RateConnectionStore(
      RateConnectionRequestModeEnum.dislike,
      mockAnalyticsStore,
      mockApiService,
      mockVpnStore,
    );
  });

  group('RateConnectionStore', () {
    test('toggleRateConnectionReason adds and removes reasons (dislike)', () {
      final reason = RateConnectionReason.dislikeReasons.first;
      dislikeModeStore.toggleRateConnectionReason(reason);
      expect(dislikeModeStore.selectedReasons, contains(reason));

      dislikeModeStore.toggleRateConnectionReason(reason);
      expect(dislikeModeStore.selectedReasons, isNot(contains(reason)));
    });

    test('toggleRateConnectionReason adds and removes reasons (like)', () {
      final reason = RateConnectionReason.likeReasons.first;
      likeModeStore.toggleRateConnectionReason(reason);
      expect(likeModeStore.selectedReasons, contains(reason));

      likeModeStore.toggleRateConnectionReason(reason);
      expect(likeModeStore.selectedReasons, isNot(contains(reason)));
    });

    test('toggleRateConnectionReason wrong reason', () {
      final reason = RateConnectionReason.likeReasons.first;
      dislikeModeStore.toggleRateConnectionReason(reason);
      expect(dislikeModeStore.selectedReasons, isNot(contains(reason)));
    });

    test('showReasons returns correct reasons for mode', () {
      expect(likeModeStore.showReasons, RateConnectionReason.likeReasons);
      expect(dislikeModeStore.showReasons, RateConnectionReason.dislikeReasons);
    });

    test('submitRateConnection throws if vpnConnection is null (like)', () async {
      await expectLater(
        likeModeStore.submitRateConnection(),
        throwsAssertionError,
      );
      verifyNever(mockAnalyticsStore.logEvent(any));
      verifyNever(mockApiService.rateConnection(request: anyNamed('request')));
    });

    test('submitRateConnection throws if vpnConnection is null (dislike)', () async {
      await expectLater(
        dislikeModeStore.submitRateConnection(),
        throwsAssertionError,
      );
      verifyNever(mockAnalyticsStore.logEvent(any));
      verifyNever(mockApiService.rateConnection(request: anyNamed('request')));
    });

    test('submitRateConnection calls api and logs analytics', () async {
      // Arrange
      likeModeStore
        ..feedback = 'Great connection!'
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first);

      final mockVpnConnection = MockVpnConnection();
      final mockKeyPair = MockKeyPair();
      when(mockVpnStore.vpnConnection).thenReturn(mockVpnConnection);
      when(mockVpnStore.wireguardKey).thenReturn(mockKeyPair);
      when(mockKeyPair.publicKey).thenReturn('pubkey');
      when(mockVpnConnection.location).thenReturn(Mocks.locationResidentialUS);
      when(
        mockApiService.rateConnection(
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await likeModeStore.submitRateConnection();

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
                  RateConnectionReason.likeReasons.first.name,
                )
                .having((r) => r.feedback, 'feedback', 'Great connection!')
                .having((r) => r.country, 'country', 'US')
                .having((r) => r.ipType, 'ipType', 'residential')
                .having((r) => r.publicKey, 'publicKey', 'pubkey'),
            named: 'request',
          ),
        ),
      ).called(1);
    });

    test('submitRateConnection calls api and logs analytics no reasons', () async {
      // Arrange
      likeModeStore.feedback = 'Great connection!';

      final mockVpnConnection = MockVpnConnection();
      final mockKeyPair = MockKeyPair();
      when(mockVpnStore.vpnConnection).thenReturn(mockVpnConnection);
      when(mockVpnStore.wireguardKey).thenReturn(mockKeyPair);
      when(mockKeyPair.publicKey).thenReturn('pubkey');
      when(mockVpnConnection.location).thenReturn(Mocks.locationResidentialUS);
      when(
        mockApiService.rateConnection(
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await likeModeStore.submitRateConnection();

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
    });

    test('submitRateConnection completes with error if api throws', () async {
      // Arrange
      likeModeStore
        ..feedback = 'Great connection!'
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first);

      final mockVpnConnection = MockVpnConnection();
      final mockKeyPair = MockKeyPair();
      when(mockVpnStore.vpnConnection).thenReturn(mockVpnConnection);
      when(mockVpnStore.wireguardKey).thenReturn(mockKeyPair);
      when(mockKeyPair.publicKey).thenReturn('pubkey');
      when(mockVpnConnection.location).thenReturn(Mocks.locationResidentialUS);
      when(
        mockApiService.rateConnection(
          request: anyNamed('request'),
        ),
      ).thenAnswer((_) async => throw Exception('API error'));

      // Act & Assert
      await expectLater(likeModeStore.submitRateConnection(), throwsA(isA<Exception>()));
    });

    test('cancelRateConnection logs analytics event', () {
      likeModeStore.cancelRateConnection();
      verify(mockAnalyticsStore.logRateConnectionCancel(RateConnectionRequestModeEnum.like))
          .called(1);
    });
  });
}
