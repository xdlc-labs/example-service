#!/usr/bin/env bash
# Minimal Fix stand-in for local xdlc loop drills (no model API).
# xdlc runs this with cwd = repo dir and prompt on stdin.
# Removes FORCE_CI_FAIL if present, commits, pushes current branch.
set -euo pipefail
cat >/dev/null || true # drain stdin prompt
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ -f FORCE_CI_FAIL ]]; then
  git rm -f FORCE_CI_FAIL
  git commit -m "fix: remove FORCE_CI_FAIL"
  git push origin "HEAD:${BRANCH}"
  echo "fake-fix: removed FORCE_CI_FAIL and pushed ${BRANCH}"
else
  echo "fake-fix: nothing to fix (no FORCE_CI_FAIL)"
fi
