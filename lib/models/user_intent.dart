enum UserIntent {
  bestSpeed('speed', requiresCluster: true),
  lowLatency('latency', requiresCluster: true),
  nearestLocation('my_location', requiresCluster: false),
  maxPrivacy('max_privacy', requiresCluster: false),
  streaming('streaming', requiresCluster: false),
  p2p('p2p', requiresCluster: true);

  const UserIntent(this.key, {required this.requiresCluster});

  final String key;
  final bool requiresCluster;
}
