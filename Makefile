.DEFAULT_GOAL := run-dev
.PHONY: run-dev clean generate

init:
	fvm flutter pub get

run-dev: init generate
	fvm flutter run --debug --flavor "dev" --dart-define "FLAVOR=DEV"

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