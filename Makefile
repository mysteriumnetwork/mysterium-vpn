.DEFAULT_GOAL := run-dev
IOS_DEVICE_MODEL = iphone15
IOS_DEVICE_VERSION = 18.0
ANDROID_DEVICE_MODEL = MediumPhone.arm
ANDROID_DEVICE_VERSION = 34
FIREBASE_PROJECT_ID = new-mysterium-vpn

init:
	fvm flutter pub get

run-dev: init generate
	fvm flutter run --debug --flavor "dev" --dart-define "FLAVOR=DEV"

clean:
	fvm flutter clean

generate: generate-code generate-localization generate-api

generate-code:
	fvm dart run build_runner build --verbose --delete-conflicting-outputs ;\
	fvm dart format --line-length 100 .

generate-localization:
	fvm dart run easy_localization:generate ;\
    fvm dart run easy_localization:generate -f keys -o locale_keys.g.dart ;\
    fvm dart format --line-length 100 .

# Generate VPN API client code using
# Tool install: https://github.com/OpenAPITools/openapi-generator
# generate command: https://openapi-generator.tech/docs/usage/#generate
# dart-dio docs: https://openapi-generator.tech/docs/generators/dart-dio
generate-api:
	cd packages/vpn_api ;\
	openapi-generator generate \
	  --input-spec https://api-test.mysteriumvpn.com/openapi.yaml \
	  --generator-name dart-dio \
	  --output . \
	  --skip-validate-spec \
	  --minimal-update \
	  --remove-operation-id-prefix \
	  --global-property apiTests=false,modelTests=false,skipFormModel=false \
	  --additional-properties=serializationLibrary=json_serializable,finalProperties=true,apiNameSuffix=,apiNamePrefix=,pubName=vpn_api ;\
  	fvm dart run build_runner build --verbose --delete-conflicting-outputs ;\
	fvm dart format --line-length 100 . ;\
	cd ..

update-tile-assets-declaration:
	fvm dart run assets/map_tiles/list_assets.dart

run-integration-tests:
	patrol test --flavor dev --flutter-command="fvm flutter" $(flags)

build-ios-integration-test:
	rm -rf build/ios_integ && \
	patrol build ios --target integration_test/example_test.dart --flavor dev --dart-define "FLAVOR=DEV" --flutter-command="fvm flutter" --verbose --release $(flags)

build-android-integration-test:
	patrol build android --target integration_test/example_test.dart --flavor dev --dart-define "FLAVOR=DEV" --flutter-command="fvm flutter" $(flags)

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
    	--app build/app/outputs/apk/dev/debug/app-dev-debug.apk \
    	--test build/app/outputs/apk/androidTest/dev/debug/app-dev-debug-androidTest.apk \
    	--device model="$(ANDROID_DEVICE_MODEL)",version="$(ANDROID_DEVICE_VERSION)",locale=en,orientation=portrait \
    	--timeout 10m \
    	--use-orchestrator \
    	--environment-variables clearPackageData=true \
		--project "$(FIREBASE_PROJECT_ID)"