#!/usr/bin/env bash
set -euo pipefail

# Usage: ENV_DEV, ENV_PROD and ENV_E2E must be provided via env (workflow secrets)
: "${ENV_DEV:?ENV_DEV is required}"
: "${ENV_PROD:?ENV_PROD is required}"
: "${ENV_E2E:?ENV_E2E is required}"

# materialize files
printf '%s' "$ENV_DEV" > .env.dev
chmod 600 .env.dev

printf '%s' "$ENV_PROD" > .env.prod
chmod 600 .env.prod

mkdir -p integration_test
chmod 700 integration_test
printf '%s' "$ENV_E2E" > integration_test/.env
chmod 600 integration_test/.env

echo "Wrote .env.dev, .env.prod and integration_test/.env"
ls -l .env.dev .env.prod integration_test/.env || true
wc -c .env.dev .env.prod integration_test/.env || true

echo "Keys and masked preview (value lengths shown):"
for f in .env.dev .env.prod integration_test/.env; do
  echo "---- $f ----"
  awk -F '=' '{
    key=$1;
    val=$2;
    for(i=3;i<=NF;i++){ val=val"="$i }
    gsub(/^[ \t]+|[ \t]+$/, "", val);
    printf "%s=<redacted> (%d bytes)\n", key, length(val)
  }' "$f" || true
done