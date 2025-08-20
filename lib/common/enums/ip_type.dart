enum IPType {
  residential,
  datacenter,
  closest;

  static IPType fromName(String name) => IPType.values.firstWhere(
        (it) => it.name == name,
        orElse: () => IPType.residential,
      );

  String? get toSerializedString => switch (this) {
        IPType.datacenter => 'hosting',
        IPType.residential => 'residential',
        _ => null,
      };
}
