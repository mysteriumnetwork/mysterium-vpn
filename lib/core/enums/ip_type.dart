enum IPType {
  residential('residential'),
  datacenter('hosting'),
  closest('');

  const IPType(this.key);

  final String key;

  static IPType fromName(String name) =>
      IPType.values.firstWhere((it) => it.name == name, orElse: () => IPType.residential);

  static IPType fromKey(String key) =>
      IPType.values.firstWhere((it) => it.key == key, orElse: () => IPType.residential);
}
