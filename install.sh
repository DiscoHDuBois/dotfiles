#!/usr/bin/env bash
# Copy home/ → ~ and config/ → ~/.config.
# Every file that would be overwritten (and differs) is saved first in
# ~/.dotfiles-backup/<timestamp>/, same relative path as under ~.
set -euo pipefail
cd "$(dirname "$0")"

backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
saved=0

install_dir() { # install_dir <src> <dest>
  local src=$1 dest=$2 f target bk
  while IFS= read -r -d '' f; do
    target="$dest/${f#"$src"/}"
    if [[ -e $target || -L $target ]] && ! cmp -s "$f" "$target"; then
      bk="$backup/${target#"$HOME"/}"
      mkdir -p "$(dirname "$bk")"
      cp -aL "$target" "$bk"   # -L: save the content even if the target is a symlink
      saved=$((saved + 1))
    fi
  done < <(find "$src" -type f -print0)
  mkdir -p "$dest"
  cp -a "$src/." "$dest/"
}

install_dir home "$HOME"
install_dir config "${XDG_CONFIG_HOME:-$HOME/.config}"
rm -rf "$HOME/.cache/fastfetch/images" # regenerate fastfetch's logo cache

if ((saved)); then
  echo "Installed. $saved overwritten file(s) saved in $backup"
else
  echo "Installed. Nothing overwritten."
fi
