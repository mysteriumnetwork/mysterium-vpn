import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_report_queue.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import '../../support/test_prefs.dart';

ReportBrokenNodeRequest request(String sessionId) => ReportBrokenNodeRequest(
  sessionId: sessionId,
  hash: 'hash',
  publicKey: 'pub',
  deviceId: 'dev',
  destinationCountry: 'de',
  originCountry: 'lt',
  osType: 'macos',
  internetType: 'wifi',
  appVersion: '1.0.0',
  trigger: ReportBrokenNodeRequestTriggerEnum.auto,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TunnelHealthReportQueue queue;
  final now = DateTime.utc(2026, 10, 15, 12);

  setUp(() async {
    queue = TunnelHealthReportQueue(await initTestPrefs(), Talker());
  });

  test('a queued report comes back on drain', () async {
    await queue.add(request('sess-1'), now: now);

    final drained = await queue.drain(now: now);

    expect(drained.map((it) => it.sessionId), ['sess-1']);
  });

  test('draining empties the queue, so a report is not sent twice', () async {
    await queue.add(request('sess-1'), now: now);
    await queue.drain(now: now);

    expect(await queue.drain(now: now), isEmpty);
  });

  test('re-queueing the same session replaces rather than duplicates', () async {
    await queue.add(request('sess-1'), now: now);
    await queue.add(request('sess-1'), now: now);

    expect(await queue.drain(now: now), hasLength(1));
  });

  test('entries older than the max age are dropped', () async {
    await queue.add(request('sess-old'), now: now);

    final later = now.add(const Duration(days: 4));

    expect(await queue.drain(now: later), isEmpty);
  });

  test('the queue is capped, dropping the oldest first', () async {
    for (var i = 0; i < 25; i++) {
      await queue.add(request('sess-$i'), now: now);
    }

    final drained = await queue.drain(now: now);

    expect(drained, hasLength(20));
    expect(drained.first.sessionId, 'sess-5');
    expect(drained.last.sessionId, 'sess-24');
  });

  test('the full payload survives a round trip', () async {
    await queue.add(request('sess-1'), now: now);

    final drained = (await queue.drain(now: now)).single;

    expect(drained.toJson(), request('sess-1').toJson());
  });
}
