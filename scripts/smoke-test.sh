#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://localhost:8080}"

health="$(curl --fail --silent "${BASE_URL}/actuator/health")"
orders="$(curl --fail --silent "${BASE_URL}/api/v1/orders")"

grep -q '"status":"UP"' <<<"${health}"
grep -q '"status":"READY"' <<<"${orders}"

echo "Smoke test passed for ${BASE_URL}"
