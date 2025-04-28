enum RateConnectionMode {
  like,
  dislike,
}

enum RateConnectionReason {
  stableConnection,
  consistentSpeed,
  lowLatency,
  accessToSites,
  frequentDisconnects,
  unstableSpeed,
  highLatency,
  geoBlockedSites,
  other;

  static List<RateConnectionReason> get likeReasons => [
        stableConnection,
        consistentSpeed,
        lowLatency,
        accessToSites,
        other,
      ];

  static List<RateConnectionReason> get dislikeReasons => [
        frequentDisconnects,
        unstableSpeed,
        highLatency,
        geoBlockedSites,
        other,
      ];
}
