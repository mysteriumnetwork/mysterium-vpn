import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/vpn/store/rate_connection_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:vpn_api/vpn_api.dart';

import 'rate_connection_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnalyticsStore>(), MockSpec<VpnStore>()])
void main() {
  late RateConnectionStore likeModeStore;
  late RateConnectionStore dislikeModeStore;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockVpnStore mockVpnStore;

  setUp(() {
    mockAnalyticsStore = MockAnalyticsStore();
    mockVpnStore = MockVpnStore();

    likeModeStore = RateConnectionStore(
      RateConnectionRequestModeEnum.like,
      mockAnalyticsStore,
      mockVpnStore,
    );

    dislikeModeStore = RateConnectionStore(
      RateConnectionRequestModeEnum.dislike,
      mockAnalyticsStore,
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

    test('toggleRateConnectionReason ignores wrong reason', () {
      final reason = RateConnectionReason.likeReasons.first;
      dislikeModeStore.toggleRateConnectionReason(reason);
      expect(dislikeModeStore.selectedReasons, isNot(contains(reason)));
    });

    test('showReasons returns correct reasons for mode', () {
      expect(likeModeStore.showReasons, RateConnectionReason.likeReasons);
      expect(dislikeModeStore.showReasons, RateConnectionReason.dislikeReasons);
    });

    test('submitRateConnection calls vpnStore and logs analytics (with reasons)', () async {
      // Arrange
      likeModeStore
        ..feedback = 'Great connection!'
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first);

      when(
        mockVpnStore.submitRateConnection(
          mode: anyNamed('mode'),
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await likeModeStore.submitRateConnection();

      // Assert
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmit)).called(1);
      verify(
        mockVpnStore.submitRateConnection(
          mode: RateConnectionRequestModeEnum.like,
          reasons: RateConnectionReason.likeReasons.first.name,
          feedback: 'Great connection!',
        ),
      ).called(1);
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmitSuccess)).called(1);
    });

    test('submitRateConnection calls vpnStore and logs analytics (no reasons)', () async {
      // Arrange
      likeModeStore.feedback = 'Great connection!';
      when(
        mockVpnStore.submitRateConnection(
          mode: anyNamed('mode'),
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      ).thenAnswer((_) async {});

      // Act
      await likeModeStore.submitRateConnection();

      // Assert
      verify(
        mockVpnStore.submitRateConnection(
          mode: RateConnectionRequestModeEnum.like,
          reasons: RateConnectionReason.other.name,
          feedback: 'Great connection!',
        ),
      ).called(1);
    });

    test('submitRateConnection rethrows if vpnStore throws', () async {
      // Arrange
      likeModeStore
        ..feedback = 'Great connection!'
        ..toggleRateConnectionReason(RateConnectionReason.likeReasons.first);

      when(
        mockVpnStore.submitRateConnection(
          mode: anyNamed('mode'),
          reasons: anyNamed('reasons'),
          feedback: anyNamed('feedback'),
        ),
      ).thenThrow(Exception('API error'));

      // Act & Assert
      await expectLater(likeModeStore.submitRateConnection(), throwsA(isA<Exception>()));
      verify(mockAnalyticsStore.logEvent(AnalyticsEvent.rateConnectionSubmitError)).called(1);
    });

    test('cancelRateConnection logs analytics event', () {
      likeModeStore.cancelRateConnection();
      verify(
        mockAnalyticsStore.logRateConnectionCancel(RateConnectionRequestModeEnum.like),
      ).called(1);
    });
  });
}
