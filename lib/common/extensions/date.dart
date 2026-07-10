import 'package:intl/intl.dart';

extension DurationExtension on Duration {
  String toHoursMinutesSeconds() {
    final hours = inHours;
    final minutes = inMinutes - hours * 60;
    final seconds = inSeconds - hours * 3600 - minutes * 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String toHoursMinutes() {
    final hours = inHours;
    final minutes = inMinutes - hours * 60;
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m';
  }
}

extension DateExtension on DateTime {
  String formatWithMonthDayYear() => DateFormat('MMM d, yyyy').format(this);
  String formatWithDay() => DateFormat('EEEE, d MMM, yyyy').format(this);
  String formatWithTime() => DateFormat('HH:mm:ss').format(this);
  String formatWithDayAndTime() => DateFormat('EEEE, d MMM, yyyy HH:mm').format(this);
  String toUnixTimestampSeconds() => (millisecondsSinceEpoch ~/ 1000).toString();
}
