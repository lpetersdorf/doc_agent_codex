#!/usr/bin/env bash
# Block read operations for known credential paths. Accepts file paths as args and exits non-zero if any match.
set -euo pipefail
for f in "$@"; do
  case "$f" in
    */.env|*/.env.*|*/credentials|*/id_rsa|*/id_ecdsa|*/.aws/*)
      echo "Blocked: read access to credential file: $f" >&2
      exit 1
      ;;
  esac
done
exit 0
