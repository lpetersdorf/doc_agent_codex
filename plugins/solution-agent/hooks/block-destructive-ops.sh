#!/usr/bin/env bash
# Block destructive ops in cloned analysis repos under /tmp/repo-analyzer-* to avoid accidental pushes.
set -euo pipefail
# Expect first arg to be the command string
cmd="$*"
if [[ "$cmd" =~ git[[:space:]]+push ]] ; then
  # If working dir is under /tmp/repo-analyzer-*, block
  cwd="$(pwd)"
  if [[ "$cwd" == /tmp/repo-analyzer-* ]]; then
    echo "Blocked: git push in cloned analysis repo is not allowed." >&2
    exit 1
  fi
fi
# Block obvious destructive shell commands
if [[ "$cmd" =~ rm[[:space:]]+-rf[[:space:]]+/ ]] ; then
  echo "Blocked: destructive rm -rf / detected." >&2
  exit 1
fi
exit 0
