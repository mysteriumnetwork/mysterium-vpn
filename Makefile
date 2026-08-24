.DEFAULT_GOAL := run-dev
IOS_DEVICE_MODEL = iphone15
IOS_DEVICE_VERSION = 18.0
ANDROID_DEVICE_MODEL = MediumPhone.arm
ANDROID_DEVICE_VERSION = 34
FIREBASE_PROJECT_ID = new-mysterium-vpn

# SPM is enabled explicitly so every machine builds the same way regardless of
# global flutter config. Apple targets use hybrid SPM + CocoaPods: SPM-capable
# plugins resolve via FlutterGeneratedPluginSwiftPackage, the rest (WireGuardKit,
# OpenVPNAdapter, OneSignal NSE) stay on CocoaPods. Two workarounds keep this
# hybrid green — remove them once fixed upstream:
# 1. ios/Podfile post_integrate strips OneSignal from CocoaPods' embed phase
#    (SPM already embeds it; two producers = "Multiple commands produce").
# 2. all macos Runner configs pass patrol's generated PatrolImpl modulemap via
#    OTHER_SWIFT_FLAGS (https://github.com/leancodepl/patrol/issues/3177).
# 3. Runner targets set ENABLE_TESTING_SEARCH_PATHS=YES: patrol_cli builds link
#    XCTest into the app, and SPM (unlike patrol's podspec) can't inject the
#    developer test-framework search paths.
# Crashlytics dSYM upload is a consequence of the same migration: the generated
# Xcode phase pointed at $PODS_ROOT and silently uploaded nothing once Firebase
# moved to SPM. It now runs in CI only (.github/scripts/upload-crashlytics-symbols.sh),
# so a build archived locally from Xcode ships without symbols. firebase.json
# keeps uploadDebugSymbols false so flutterfire configure can't re-add the phase.
init:
	fvm flutter config --enable-swift-package-manager
	fvm flutter pub get

run-dev: init generate
	fvm flutter run --debug --flavor "dev" --dart-define-from-file ".env.dev"

clean:
	fvm flutter clean

generate: generate-code

generate-code:
	fvm dart run build_runner build --verbose --delete-conflicting-outputs ;\
	fvm dart format --line-length 100 .

# ─── Localizely (translations) ───────────────────────────────────────────────
# Needs a Localizely *management* API token (Localizely > Account settings > API
# tokens) — this is NOT the runtime SDK token kept in .env.dev/.env.prod.
# The token is resolved in this order: LOCALIZELY_API_TOKEN env var, then the
# gitignored .env.localizely file (LOCALIZELY_API_TOKEN=...). Both are kept out
# of git. The project id is read from pubspec.yaml (flutter_intl > localizely).

# Resolves the API token into the shell var $$token (env var, then
# .env.localizely), or exits with an error. Shared by fetch/upload recipes.
define resolve_localizely_token
token="$${LOCALIZELY_API_TOKEN}"; \
if [ -z "$$token" ] && [ -f .env.localizely ]; then \
  token="$$(grep -E '^LOCALIZELY_API_TOKEN=' .env.localizely | head -n1 | cut -d= -f2-)"; \
fi; \
if [ -z "$$token" ]; then \
  echo "ERROR: LOCALIZELY_API_TOKEN not set (export it, pass it inline, or add it to .env.localizely)"; exit 1; \
fi
endef

# Pull the latest translations from Localizely into lib/l10n/*.arb.
localizely-fetch:
	@$(resolve_localizely_token); \
	fvm dart run intl_utils:localizely_download --api-token "$$token"

# Upload the source (en) ARB to Localizely — adds new keys without overwriting
# existing translations. Pass `flags=--upload-overwrite` when an existing en
# string was corrected, otherwise the fix is dropped and the next fetch reverts it.
localizely-upload:
	@$(resolve_localizely_token); \
	fvm dart run intl_utils:localizely_upload_main --api-token "$$token" $(flags)

# Regenerate the S localization class (intl_utils) + the Tr.byKey bridge, then
# format. Uses the standalone bridge generator (fast) rather than build_runner;
# `make generate` regenerates the bridge too via the tr_bridge builder, and the
# drift-guard test keeps the two in sync.
localizely-generate:
	fvm dart run intl_utils:generate ;\
	fvm dart run tool/tr_bridge_generator.dart ;\
	fvm dart format --line-length 100 lib/generated lib/l10n

# Pull the latest translations and regenerate in one step.
localizely-sync: localizely-fetch localizely-generate

update-tile-assets-declaration:
	fvm dart run assets/map_tiles/list_assets.dart

run-unit-tests:
	fvm flutter test --dart-define-from-file=.env.dev --dart-define _DOTENV_FILE=.env.dev && \
    fvm flutter test --dart-define-from-file=.env.prod --dart-define _DOTENV_FILE=.env.prod test/env_test.dart

debug-integration-tests:
	patrol develop --flavor dev --flutter-command="fvm flutter" --dart-define-from-file "integration_test/.env" $(flags)

run-integration-tests:
	patrol test --flavor dev --flutter-command="fvm flutter" --dart-define-from-file "integration_test/.env" $(flags)

build-ios-integration-test:
	rm -rf build/ios_integ && \
	patrol build ios --flavor dev --dart-define-from-file "integration_test/.env" --flutter-command="fvm flutter" --verbose --release $(flags)

build-android-integration-test:
	patrol build android --flavor dev --dart-define-from-file "integration_test/.env" --flutter-command="fvm flutter" --verbose $(flags)

build-android-dev-debug:
	fvm flutter build apk --debug --flavor dev --dart-define-from-file ".env.dev"

build-android-dev-release:
	fvm flutter build apk --release --flavor dev --dart-define-from-file ".env.dev"
	
	
run-ios-testlab:
	cd build/ios_integ/Build/Products && \
    rm -f ios_tests.zip && \
    zip -r ios_tests.zip . && \
    cd - && \
	gcloud firebase test ios run \
		--type xctest \
		--test "build/ios_integ/Build/Products/ios_tests.zip" \
		--device model="$(IOS_DEVICE_MODEL)",version="$(IOS_DEVICE_VERSION)",locale=en_US,orientation=portrait \
		--timeout 45m \
		--project "$(FIREBASE_PROJECT_ID)"

run-android-testlab:
	gcloud firebase test android run \
    	--type instrumentation \
		--app $(shell find build/app/outputs/apk/dev -name "*.apk" | head -n 1) \
		--test $(shell find build/app/outputs/apk/androidTest/dev -name "*.apk" | head -n 1) \
    	--device model="$(ANDROID_DEVICE_MODEL)",version="$(ANDROID_DEVICE_VERSION)",locale=en,orientation=portrait \
    	--timeout 45m \
    	--use-orchestrator \
    	--environment-variables clearPackageData=true \
		--project "$(FIREBASE_PROJECT_ID)"
