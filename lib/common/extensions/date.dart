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
