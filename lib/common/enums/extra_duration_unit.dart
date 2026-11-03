/// Unit of a subscription's bonus (`extra_duration`) period.
///
/// Mirrors the `vpn_api` wire enum so the API type does not leak past the
/// repository.
enum ExtraDurationUnit { day, week, month, year }
