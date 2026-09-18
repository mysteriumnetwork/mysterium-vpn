#!/usr/bin/env bash
# Enforces the one-directional data flow: services -> repositories -> stores -> UI.
# A layer may import downward and sideways, never upward.
#
# Matches `import` and `export`, and both `package:mysterium_vpn/<layer>/` and
# relative `../<layer>/` forms — the violation this check was written for was a
# relative *export*.
#
# Known limit: only direct directives are checked, so an upward edge laundered
# through a barrel in a permitted directory would not be caught. The barrels
# reachable from the data layer are verified clean as of this writing; a
# graph-resolving lint is the durable fix.
set -uo pipefail

status=0

# A missing directory means the check cannot run; fail rather than report a
# vacuous pass, otherwise a rename silently disables enforcement.
require_dirs() {
  local missing=0
  for dir in "$@"; do
    if [ ! -d "${dir}" ]; then
      echo "✗ ${dir} not found - run from the repo root, or update this script after a rename"
      missing=1
    fi
  done
  return "${missing}"
}

check() {
  local label=$1 dir=$2 forbidden=$3
  local hits leaves
  require_dirs "${dir}" || { status=1; return; }
  # A relative directive names a sibling by its last segment (../ui/), not by
  # the full token (../common/ui/), so match both forms.
  leaves=$(printf '%s' "${forbidden}" | tr '|' '\n' | sed 's|.*/||' | paste -sd'|' -)
  hits=$(grep -rnE "^\s*(import|export)\s+'(package:mysterium_vpn/(${forbidden})|(\.\./)+((${forbidden})|(${leaves})))/" \
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

# common/ui holds helpers that need widgets or stores; common/utils stays pure
# so any layer can use it — enforced at the definition site just below.
check "lib/services"     lib/services     "providers|stores|views|pages|components|repositories|debug|common/ui"
check "lib/repositories" lib/repositories "providers|stores|views|pages|components|debug|common/ui"
# Stores reach storage through a repository, never directly. services/data
# holds the storage primitives; the rest of services/ is fair game.
check "lib/stores"       lib/stores       "providers|views|pages|components|debug|services/data"

# common/utils must stay importable from every layer, so it may not reach up.
check "lib/common/utils" lib/common/utils "providers|stores|views|pages|components|debug|common/ui"

# The UI talks to the app's own models, never to the backend client directly.
if ! require_dirs lib/views lib/pages lib/components; then
  status=1
elif ui_api=$(grep -rn "package:vpn_api/" lib/views lib/pages lib/components --include='*.dart'); then
  echo "✗ lib/views, lib/pages, lib/components must not import package:vpn_api"
  echo "${ui_api}" | sed 's/^/    /'
  status=1
else
  echo "✓ lib/views, lib/pages, lib/components (no vpn_api)"
fi

if [ "${status}" -ne 0 ]; then
  echo
  echo "Give the lower layer a narrow port it owns (see lib/services/mqtt/mqtt_experiment_flag.dart),"
  echo "or map to an app model at the boundary (see lib/repositories/news_center/rest_news_center_repository.dart)."
fi

exit "${status}"
