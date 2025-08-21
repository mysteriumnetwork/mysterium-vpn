enum RateConnectionReason {
  stableConnection,
  consistentSpeed,
  lowLatency,
  accessToSites,
  frequentDisconnects,
  unstableSpeed,
  highLatency,
  geoBlockedSites,
  incorrectLocation,
  other;

  static const List<RateConnectionReason> likeReasons = [
    stableConnection,
    consistentSpeed,
    lowLatency,
    accessToSites,
    other,
  ];

  static const List<RateConnectionReason> dislikeReasons = [
    frequentDisconnects,
    unstableSpeed,
    highLatency,
    geoBlockedSites,
    incorrectLocation,
    other,
  ];
}
