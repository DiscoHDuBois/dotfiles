#!/usr/bin/env bash
# Restore gnome/dconf/*.ini → dconf (install the extensions in extensions.txt first)
set -euo pipefail
cd "$(dirname "$0")"

for f in dconf/*.ini; do
  p="/$(basename "$f" .ini | tr . /)/"
  echo "load $p"
  dconf load "$p" < "$f"
done

echo "Done. Log out and back in if some extensions don't pick up the settings."
