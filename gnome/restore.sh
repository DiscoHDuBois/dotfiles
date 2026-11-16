#!/usr/bin/env bash
# Restore gnome/dconf/*.ini → dconf (install the extensions in extensions.txt first)
set -euo pipefail
cd "$(dirname "$0")"

# Backup of the whole current dconf (restore with: dconf load / < file)
mkdir -p "$HOME/.dotfiles-backup"
bk="$HOME/.dotfiles-backup/dconf-$(date +%Y%m%d-%H%M%S).ini"
dconf dump / > "$bk"
echo "Backup: $bk"

for f in dconf/*.ini; do
  p="/$(basename "$f" .ini | tr . /)/"
  echo "load $p"
  dconf load "$p" < "$f"
done

echo "Done. Log out and back in if some extensions don't pick up the settings."
