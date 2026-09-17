// Local storage primitives.
//
// The enforced rule is narrower than "repositories only": lib/stores and the
// UI must not import this, so state goes through a repository. That is what
// .github/scripts/check-layering.sh checks.
//
// Legitimately imported by:
//   - lib/repositories/**            the intended owners
//   - lib/providers/service_providers.dart   composition root, constructs them
//   - lib/entrypoints/app_initializer.dart   startup, initializes them
//   - sibling services in lib/services/data/ (e.g. config_cat_cache.dart)
export 'local/local_db_service.dart';
export 'local/secured_storage_service.dart';
export 'local/shared_preferences_service.dart';
