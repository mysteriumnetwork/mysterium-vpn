/// The tunnel configuration could not be read — which is not the same as there
/// being none. The store has already surfaced it through `connectionError`, so
/// callers only need to stop, not report it again.
class TunnelCheckFailedException implements Exception {
  const TunnelCheckFailedException();
}
