#!/usr/bin/env bash
# Enforces the one-directional data flow: services -> repositories -> stores -> UI.
# A layer may import downward and sideways, never upward.
#
# Matches `import` and `export`, and both `package:mysterium_vpn/<layer>/` and
# relative `../<layer>/` forms — the violation this check was written for was a
# relative *export*.
#
# Known limit: only direct directives are checked, so an upward edge laundered
# through a barrel in a permitted directory is not caught. lib/common re-exports
# store- and widget-dependent helpers today, so services importing
# common/utils/utils.dart still reaches stores transitively.
set -uo pipefail

status=0

check() {
  local label=$1 dir=$2 forbidden=$3
  local hits
  hits=$(grep -rnE "^\s*(import|export)\s+'(package:mysterium_vpn/|(\.\./)+)(${forbidden})/" \
    "${dir}" --include='*.dart' 2>/dev/null \
    | grep -v '\.g\.dart:\|\.freezed\.dart:\|\.mocks\.dart:') || true
  if [ -n "${hits}" ]; then
    echo "✗ ${label} must not depend on: ${forbidden//|/, }"
    echo "${hits}" | sed 's/^/    /'
    status=1
  else
    echo "✓ ${label}"
  fi
}

check "lib/services"     lib/services     "providers|stores|views|pages|components|repositories|debug"
check "lib/repositories" lib/repositories "providers|stores|views|pages|components|debug"
check "lib/stores"       lib/stores       "views|pages|components|debug"

# The UI talks to the app's own models, never to the backend client directly.
ui_api=$(grep -rn "package:vpn_api/" lib/views lib/pages lib/components --include='*.dart' 2>/dev/null) || true
if [ -n "${ui_api}" ]; then
  echo "✗ lib/views, lib/pages, lib/components must not import package:vpn_api"
  echo "${ui_api}" | sed 's/^/    /'
  status=1
else
  echo "✓ lib/views, lib/pages, lib/components (no vpn_api)"
fi

if [ "${status}" -ne 0 ]; then
  echo
  echo "Give the lower layer a narrow port it owns (see lib/services/mqtt/mqtt_experiment_flag.dart),"
  echo "or map to an app model at the boundary (see lib/services/news_center/rest_news_center_service.dart)."
fi

exit "${status}"
