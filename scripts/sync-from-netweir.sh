#!/bin/sh
# Copies the parser core from a Netweir checkout into crates/parsec, where
# Netweir's crates/netweir-html is the source: a parser change is made
# there first, then synced here. Everything else in this repo (bindings,
# the C API, other modules, benchmarks) is Parsec's own.
#
#   scripts/sync-from-netweir.sh ../netweir          copy, and record the commit
#   scripts/sync-from-netweir.sh --check ../netweir  fail if crates/parsec differs
#
# The check runs in CI against the commit in NETWEIR_COMMIT.
set -eu
check=
if [ "${1:-}" = "--check" ]; then
  check=1
  shift
fi
netweir=${1:?usage: scripts/sync-from-netweir.sh [--check] NETWEIR_CHECKOUT}
from="$netweir/crates/netweir-html"
[ -d "$from/src" ] || { echo "no crates/netweir-html in $netweir" >&2; exit 1; }
here=$(cd "$(dirname "$0")/.." && pwd)
to="$here/crates/parsec"

# What's synced: the source, tests, examples, scripts and fuzz target. The
# test data (html5lib-tests, a submodule; tree-construction, pinned WPT
# files) and the manifests are Parsec's own.
synced="src examples scripts fuzz/fuzz_targets tests/css.rs tests/tokenizer.rs tests/tree.rs"

rename() {
  sed -e 's/netweir_html/parsec/g' -e 's/netweir-html/parsec-html/g' "$1"
}

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT
for item in $synced; do
  if [ -d "$from/$item" ]; then
    (cd "$from" && find "$item" -type f) | while read -r file; do
      mkdir -p "$out/$(dirname "$file")"
      rename "$from/$file" > "$out/$file"
    done
  else
    mkdir -p "$out/$(dirname "$item")"
    rename "$from/$item" > "$out/$item"
  fi
done

if [ -n "$check" ]; then
  status=0
  for item in $synced; do
    diff -r "$out/$item" "$to/$item" || status=1
  done
  if [ $status -ne 0 ]; then
    echo "crates/parsec has drifted from Netweir's crates/netweir-html at $(cat "$here/NETWEIR_COMMIT")." >&2
    echo "Make the change in Netweir first, then run scripts/sync-from-netweir.sh." >&2
  fi
  exit $status
fi

for item in $synced; do
  rm -rf "${to:?}/$item"
  mkdir -p "$(dirname "$to/$item")"
  cp -R "$out/$item" "$to/$item"
done
git -C "$netweir" rev-parse HEAD > "$here/NETWEIR_COMMIT"
echo "synced crates/parsec from Netweir $(cat "$here/NETWEIR_COMMIT")"
