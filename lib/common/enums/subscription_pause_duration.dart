enum SubscriptionPauseDuration {
  oneMonth(value: 1),
  threeMonths(value: 3),
  sixMonths(value: 6);

  const SubscriptionPauseDuration({required this.value});

  final int value;
}
