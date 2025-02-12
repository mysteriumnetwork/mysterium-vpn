.DEFAULT_GOAL := run-dev
.PHONY: run-dev clean generate

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
	pushd packages/vpn_api ;\
	openapi-generator generate \
	  --input-spec https://api-test.mysteriumvpn.com/openapi.yaml \
	  --generator-name dart-dio \
	  --output . \
	  --skip-validate-spec \
	  --minimal-update \
	  --remove-operation-id-prefix \
	  --global-property apiTests=false,modelTests=false,skipFormModel=false \
	  --additional-properties=serializationLibrary=json_serializable,finalProperties=true,apiNameSuffix=,apiNamePrefix=,pubName=vpn_api ;\
	echo "Generate API client code done" ;\
  	fvm dart run build_runner build --verbose --delete-conflicting-outputs ;\
	fvm dart format --line-length 100 . ;\
	popd