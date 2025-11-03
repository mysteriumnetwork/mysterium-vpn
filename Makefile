.DEFAULT_GOAL := run-dev
IOS_DEVICE_MODEL = iphone15
IOS_DEVICE_VERSION = 18.0
ANDROID_DEVICE_MODEL = MediumPhone.arm
ANDROID_DEVICE_VERSION = 34
FIREBASE_PROJECT_ID = new-mysterium-vpn

init:
	fvm flutter pub get

run-dev: init generate
	fvm flutter run --debug --flavor "dev" --dart-define-from-file ".env.dev"

clean:
	fvm flutter clean

generate: generate-code generate-localization

generate-code:
	fvm dart run build_runner build --verbose --delete-conflicting-outputs ;\
	fvm dart format --line-length 100 .

generate-localization:
	fvm dart run easy_localization:generate ;\
    fvm dart run easy_localization:generate -f keys -o locale_keys.g.dart ;\
    fvm dart format --line-length 100 .

fetch-localization:
	fvm dart run easy_localization_sheet

update-tile-assets-declaration:
	fvm dart run assets/map_tiles/list_assets.dart

run-unit-tests:
	fvm flutter test --dart-define-from-file=.env.dev --dart-define _DOTENV_FILE=.env.dev ;\
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
		--timeout 10m \
		--project "$(FIREBASE_PROJECT_ID)"

run-android-testlab:
	gcloud firebase test android run \
    	--type instrumentation \
		--app $(shell find build/app/outputs/apk/dev -name "*.apk" | head -n 1) \
		--test $(shell find build/app/outputs/apk/androidTest/dev -name "*.apk" | head -n 1) \
    	--device model="$(ANDROID_DEVICE_MODEL)",version="$(ANDROID_DEVICE_VERSION)",locale=en,orientation=portrait \
    	--timeout 10m \
    	--use-orchestrator \
    	--environment-variables clearPackageData=true \
		--project "$(FIREBASE_PROJECT_ID)"
