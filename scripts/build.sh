#!/usr/bin/env bash
# Cloudflare Pages / CI: same as local production build, then verify critical output.
# Jekyll writes HTML routes at _site/<path>/index.html — e.g. Work tab → _site/work/index.html
# (That is next to _site/assets/, not inside assets/.)
set -euo pipefail

export BUNDLE_WITHOUT="${BUNDLE_WITHOUT:-development}"
export JEKYLL_ENV="${JEKYLL_ENV:-production}"

bundle install
bundle exec jekyll build

if [[ ! -f _site/work/index.html ]]; then
  echo "ERROR: _site/work/index.html is missing after build."
  echo "Contents of _site (top level):"
  ls -la _site || true
  echo "---"
  echo "If you only looked under assets/ in the dashboard, note: work/ is a sibling of assets/, not inside it."
  exit 1
fi

echo "OK: _site/work/index.html exists ($(wc -c < _site/work/index.html) bytes)"
