#!/usr/bin/env bash
# Enforces the one-directional data flow: services -> repositories -> stores -> UI.
# A layer may import downward and sideways, never upward.
set -uo pipefail

status=0

report() {
  local layer=$1 forbidden=$2 dir=$3
  local hits
  hits=$(grep -rn "package:mysterium_vpn/\(${forbidden}\)/" "${dir}" \
    --include='*.dart' 2>/dev/null | grep -v '\.g\.dart:\|\.freezed\.dart:') || true
  if [ -n "${hits}" ]; then
    echo "✗ ${layer} must not import ${forbidden//\\|/, }:"
    echo "${hits}" | sed 's/^/    /'
    status=1
  else
    echo "✓ ${layer}"
  fi
}

report "lib/services"     "providers\|stores\|views\|pages\|components\|repositories" lib/services
report "lib/repositories" "providers\|stores\|views\|pages\|components"               lib/repositories
report "lib/stores"       "views\|pages\|components"                                  lib/stores

if [ "${status}" -ne 0 ]; then
  echo
  echo "Give the lower layer a narrow port it owns (see lib/services/mqtt/mqtt_experiment_flag.dart)"
  echo "and have the upper-layer type implement it, instead of importing upward."
fi

exit "${status}"
