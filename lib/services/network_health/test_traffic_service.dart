import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';
import 'package:mysterium_vpn/common/utils/resolve_error_msg.dart';
import 'package:vpn_api/vpn_api.dart';

/// Durations the QA toolbox offers. The backend floor is 30s — the generated
/// client's doc comment still says 10 because 1.0.104 predates that change, so
/// nothing here may go below 30 or the request is rejected.
const kTestTrafficDurations = <int>[30, 60, 120, 300];

/// Delays that land the tunnelled probe leg inside the window the classifier
/// actually compares. Below `degradedFloorMs` nothing is reported; past the 5s
/// probe timeout the leg fails outright and the dead-tunnel branch fires
/// instead, so the latency comparison is never exercised.
const kTestTrafficDelaysMs = <int>[150, 400, 700, 1000];

/// How long to wait for an acknowledgement before assuming it cannot arrive.
/// Short on purpose: these actions break the tunnel the answer travels back
/// through, so waiting out the shared 15s timeout burns the test window.
const _ackWindow = Duration(seconds: 5);

/// Whether the backend confirmed the action.
enum TestTrafficOutcome {
  /// Acknowledged.
  confirmed,

  /// No answer inside the ack window. Expected when the action kills the tunnel
  /// the answer would come back through — the condition is applied regardless,
  /// and the backend arms its undo before applying precisely for this case.
  unconfirmed,
}

/// Testnet-only traffic controls, for breaking your own tunnel on purpose.
///
/// Every call targets the caller's own device: the backend reads it from the
/// session, so there is nothing to pass and nothing to get wrong.
class TestTrafficService {
  const TestTrafficService(this._api);

  final Connection _api;

  /// Drops all tunnel traffic, DNS included, clearing itself after
  /// [durationSeconds]. The device cannot cancel it — that is the point.
  Future<TestTrafficOutcome> drop({required int durationSeconds}) => _send(
    (extra) => _api.testTrafficDrop(
      testTrafficDropRequest: TestTrafficDropRequest(durationSeconds: durationSeconds),
      extra: extra,
    ),
  );

  /// Adds [delayMs] of per-packet latency in each direction.
  Future<TestTrafficOutcome> delay({required int delayMs, required int durationSeconds}) => _send(
    (extra) => _api.testTrafficDelay(
      testTrafficDelayRequest: TestTrafficDelayRequest(
        delayMs: delayMs,
        durationSeconds: durationSeconds,
      ),
      extra: extra,
    ),
  );

  /// Disconnects the upstream provider once. Not a toggle: every delivery
  /// disconnects again, which is why retries are disabled for it.
  Future<TestTrafficOutcome> disconnectProvider() =>
      _send((extra) => _api.testTrafficProviderDisappearance(extra: extra));

  /// Clears drop and delay together.
  Future<TestTrafficOutcome> reset() => _send((extra) => _api.testTrafficReset(extra: extra));

  /// Sends a request whose *delivery* is the side effect.
  ///
  /// Retries are disabled: a resend is not free here, and for provider
  /// disappearance each one disconnects again. The bytes are on the wire before
  /// the wait begins, so giving up on the answer costs nothing.
  Future<TestTrafficOutcome> _send(Future<void> Function(Map<String, dynamic> extra) call) async {
    try {
      await call(kNoRetryExtra).timeout(_ackWindow);
      return TestTrafficOutcome.confirmed;
    } on TimeoutException {
      return TestTrafficOutcome.unconfirmed;
    } on DioException catch (e) {
      if (_ackCouldNotArrive(e)) {
        return TestTrafficOutcome.unconfirmed;
      }
      rethrow;
    }
  }

  /// Whether the failure means "no answer" rather than "rejected".
  ///
  /// ApiErrorsInterceptor converts any response it could read into an
  /// [ApiException] carrying the status in `code` and dropping `response`, so
  /// checking `response` alone would read every rejection as silence.
  bool _ackCouldNotArrive(DioException e) => e is! ApiException && e.response == null;
}

/// Turns a failure into something a tester can act on. A 404 and a 502 mean
/// very different things here and are easy to confuse.
String describeTestTrafficError(Object error) {
  if (error is! ApiException) {
    return resolveErrorMessage(error);
  }
  return switch (error.code) {
    404 => 'Not deployed here — TEST_TRAFFIC_TOKEN is unset on this environment',
    502 => 'Reached the API, but the upstream traffic-control call failed',
    400 => 'Rejected: ${error.message}',
    _ => '${error.message} [${error.code}]',
  };
}
