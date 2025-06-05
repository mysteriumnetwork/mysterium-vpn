enum IPType {
  residential,
  datacenter,
  closest;

  static IPType fromName(String name) => IPType.values.firstWhere(
        (it) => it.name == name,
        orElse: () => IPType.residential,
      );
}
