part of 'hooks.dart';

void useAutoSelectIPType() {
  final context = useContext();
  useEffect(() {
    final ref = ProviderScope.containerOf(context, listen: false);
    final vpnStore = ref.read(vpnStorePOD);
    final locationsStore = ref.read(locationsStorePOD);

    final disposer = reaction(
      (_) => (vpnStore.location?.id, vpnStore.location?.ipType, locationsStore.locationTypes),
      (data) {
        final (location, ipType, availableTypes) = data;

        if ((location != null && ipType == null) || ipType == IPType.closest) {
          return;
        }

        final previous = ref.read(locationsQueryStorePOD).ipType;
        final selected = availableTypes.contains(ipType)
            ? ipType
            : availableTypes.contains(previous)
            ? previous
            : availableTypes.firstOrNull;

        if (selected == null) {
          return;
        }

        ref.read(locationsQueryStorePOD).setIPType(selected);
      },
      fireImmediately: true,
      // Compare by contents: locationTypes is a fresh list on every refresh.
      equals: (a, b) {
        if (a == null || b == null) {
          return identical(a, b);
        }
        final (aId, aType, aTypes) = a;
        final (bId, bType, bTypes) = b;
        return aId == bId && aType == bType && listEquals(aTypes, bTypes);
      },
    );

    return disposer.call;
  }, []);
}
