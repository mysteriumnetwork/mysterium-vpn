import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/news_time_label.dart';

void main() {
  const labels = NewsTimeLabels(
    justNow: 'Just now',
    minutesAgo: _minutesAgo,
    hoursAgo: _hoursAgo,
    daysAgo: _daysAgo,
  );

  final now = DateTime.utc(2026, 7, 14, 12);

  String label(DateTime createdAt) => newsTimeLabel(createdAt, now: now, labels: labels);

  test('under a minute shows "Just now"', () {
    expect(label(now.subtract(const Duration(seconds: 30))), 'Just now');
    expect(label(now), 'Just now');
  });

  test('a future timestamp shows "Just now"', () {
    expect(label(now.add(const Duration(minutes: 5))), 'Just now');
  });

  test('minutes are shown compactly', () {
    expect(label(now.subtract(const Duration(minutes: 1))), '1min ago');
    expect(label(now.subtract(const Duration(minutes: 12))), '12min ago');
    expect(label(now.subtract(const Duration(minutes: 59))), '59min ago');
  });

  test('hours are shown compactly', () {
    expect(label(now.subtract(const Duration(hours: 1))), '1h ago');
    expect(label(now.subtract(const Duration(hours: 23))), '23h ago');
  });

  test('days are shown compactly up to a week', () {
    expect(label(now.subtract(const Duration(days: 1))), '1d ago');
    expect(label(now.subtract(const Duration(days: 6))), '6d ago');
  });

  test('a week or older shows an absolute day-month date', () {
    expect(label(DateTime.utc(2026, 5, 2)), '2 May');
    expect(label(DateTime.utc(2026, 5, 14)), '14 May');
  });
}

String _minutesAgo(int n) => '${n}min ago';
String _hoursAgo(int n) => '${n}h ago';
String _daysAgo(int n) => '${n}d ago';
