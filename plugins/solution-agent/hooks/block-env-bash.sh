#!/usr/bin/env bash
# Block bash usage that references sensitive credential files. Exit non-zero if suspicious file paths are present in the arguments.
set -euo pipefail
suspicious=0
for a in "$@"; do
  case "$a" in
    *.env|.env*|*.pem|credentials|id_rsa|id_ecdsa|*.key|.aws/*|~/.aws/*)
      suspicious=1
      ;;
  esac
done
if [ "$suspicious" -eq 1 ]; then
  echo "Blocked: command references potential credential files." >&2
  exit 1
fi
exit 0
