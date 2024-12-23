enum IPType {
  residential,
  datacenter;

  static IPType fromName(String name) => IPType.values.firstWhere((it) => it.name == name);
}
