#!/usr/bin/env bash
# Opposite of install.sh: copy the system's current version of each file back into the repo
# (~ → home/, ~/.config → config/), then re-export GNOME (gnome/export.sh).
# Only files that already exist in the repo are updated: new files are never added.
# Nothing is staged or committed: review with `git diff`, undo with `git restore <file>`.
set -euo pipefail
cd "$(dirname "$0")"

updated=()
conflicts=()

sync_dir() { # sync_dir <repo dir> <system dir>
  local repo=$1 sys=$2 f src
  while IFS= read -r -d '' f; do
    src="$sys/${f#"$repo"/}"
    if [[ ! -e $src ]]; then
      echo "skip (not on this system): $src"
    elif ! cmp -s "$src" "$f"; then
      if [[ -n $(git status --porcelain -- "$f") ]]; then
        # Edited in the repo and not committed: don't overwrite it with the system's copy
        conflicts+=("$f")
      else
        cp "$src" "$f" # follows symlinks, keeps the repo file's permissions
        updated+=("$f")
      fi
    fi
  done < <(find "$repo" -type f -print0 | sort -z)
}

sync_dir home "$HOME"
sync_dir config "${XDG_CONFIG_HOME:-$HOME/.config}"

if command -v dconf >/dev/null && command -v gnome-extensions >/dev/null; then
  ./gnome/export.sh
else
  echo "skip GNOME export (dconf/gnome-extensions not available)"
fi

echo
if ((${#updated[@]})); then
  echo "Updated from the system:"
  printf '  %s\n' "${updated[@]}"
else
  echo "home/ and config/: already up to date."
fi
if ((${#conflicts[@]})); then
  echo
  echo "!! NOT synced: changed both in the repo (uncommitted) and on the system:"
  printf '  %s\n' "${conflicts[@]}"
  echo "   Commit/restore the repo version, or run ./install.sh, then sync again."
fi

# Early warning on secrets in the uncommitted changes (the pre-commit hook blocks them anyway)
if command -v gitleaks >/dev/null; then
  if ! gitleaks git --pre-commit --redact --no-banner -v -l error; then
    echo
    echo "!! WARNING: gitleaks found possible secrets (above). The commit will be blocked."
  fi
else
  echo "!! gitleaks not installed: secrets not checked (sudo dnf install gitleaks)"
fi

echo
git status --short -- home config gnome
